//
//  ViewController.m
//  Woof
//
//  Created by Mattia Campana on 25/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "ViewController.h"
#import "AccountManager.h"
#import "DataSource.h"
#import "FormValidator.h"
#import "DataSource.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize bannerView, loginViewContainer, formContainer, backgroundTaskIndicator, labelTask, emailText, passwordText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkLogin) userInfo:nil repeats:NO];
    
    /*
     * TODO:
     *  1)  Visualizzata la splash screen (questa), controllare se l'utente è loggato.
     *      Se è loggato continua punto (2), altrimenti punto (5)
     *
     *  2)  Visualizzare la View che conterrà il banner
     *  3)  Contattare il server in background e visualizzare il banner restituito (contenuto HTML?) per un tot di secondi (3? 5?)
     *  4)  Passare alla Home
     
     *  5)  FadeOut del logo e FadeIn della View che contiene il Login
     *
     *
     *  ATTENZIONE: spostare tutto in viewDidAppear ----> problema segue modal
     */
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(switchToBanner) userInfo:nil repeats:NO];
}

-(void) checkLogin{
    
    //Check login
    if([DataSource getTokenDefault] == NULL) [self fadeIn:loginViewContainer withDuration:1 andWait:0];
    else [self switchToHome];

}

- (void) viewDidAppear:(BOOL)animated{
    //[self switchToHome];
}

//effetto transizione di uscita
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

//effetto transizione di entrata
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

- (void)switchToBanner{
    bannerView.alpha = 1.0;
    //[self fadeIn:bannerView withDuration:3 andWait:1 ];
}

- (void)switchToHome{
    [self performSegueWithIdentifier:@"splashToHome" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClick:(id)sender {
    if ([emailText.text isEqualToString:@""] || [passwordText.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Inserire username e password per il login!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    if (![FormValidator validateEmail:emailText.text]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Formato email non valido!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    if (passwordText.text.length < 6) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"La password deve essere di almeno 6 caratteri!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    [self fadeOut:formContainer withDuration:1 andWait:0];
    [backgroundTaskIndicator startAnimating];
    labelTask.text = @"Login in corso";
    [self performSelectorInBackground:@selector(simpleLogin) withObject:nil];
    
}

- (void)simpleLogin{
    NSString *token = [AccountManager simpleLoginWith:emailText.text andPassword:passwordText.text];
    if (token == NULL) {
        [self performSelectorOnMainThread:@selector(onErrorSimpleLogin) withObject:nil waitUntilDone:NO];
    } else {
        //set loginPref
        [DataSource setLoginDefaultsWith:emailText.text andPassword:passwordText.text andToken:token];
        // getUserInfo e salva nel db
        User * user = [AccountManager getUserInfoWith:token andEmail:emailText.text];
        NSLog(@"NUMERO LOGIN: %d", [AccountManager getUserNCheckinsWith:token andIdUser:user.idUser]);
        //passa alla home
        [self performSegueWithIdentifier:@"splashToHome" sender:self];
    }
        

}

- (void) onErrorSimpleLogin{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email e/o password errati!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
