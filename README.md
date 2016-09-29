MLooper
====================

Hey everyone, sorry I didn't have time to put up an ideal set of instructions on how-to-use. I didn't realize it would gain the traction that it did.. 

Okay, enough excuses. Here's some info to get you started (if you're running it on Heroku).


# Setup Sendgrid

1. Setup Inbound Parse on Sendgrid (https://app.sendgrid.com/settings/parse)
2. Give Inbound Parse a **domain name** to watch and an **endpoint to trigger**. For the mlooper, this would trigger: http://www.mlooper.com/email_processor


# Setup Heroku Scheduler

1. Create a job in Heroku scheduler to run `rake reply_to_spammers` every 10 minutes.

# Database

1. Create a Postgres (or MySQL) database
2. Create a user account (required fields are: email, looper_name, looper_title, password, privacy*)
3. Create some "Replacements" — basically, a way for you to replace your full name with some fake name. i.e. (replace "brian weinreich" with "john doe")
4. Create some "Replies" — the pre-generated replies the looper should use

* The privacy setting is how you toggle the default conversation privacy. If you forward a new email to the sp@mlooper.com it will either be available for anyone to see, or private and only visible to your logged-in user account.

# Test it out

I believe that's about it. You might need some customization to get it rolling for your own custom domain (I might have hard-coded some things to work only for mlooper.com domain).

# Few Big Disclaimers!

1. Make sure you get the "Replacements" correct. Replace your phone number, email, full name, company name, etc. You don't want those items to show up in the email out to the spammer (or they'll figure you out).
2. The email parses is finnicky. Every email provider works a bit different in how they send a forwarded email. So, there might be some errors when parsing through the forwarded email to find the spammers email address if you use a client other than Gmail or Inbox.

# Tests?

No real tests :( Sorry— this was a definite hack to have some fun. 

# Notes...

Gmail forwarded messages look like:
----------------
```
John Doe
Call: 123-1234 email: <bs@fake.com>
	---------- Forwarded message ----------
From: Bizzy B <bizzle@wizzle.com>
Date: Sun, Feb 22, 2015 at 4:00 PM
Subject: Fwd: Re: Git Access​
To: dizzle@gizzle.com
This is some text
```

Mailbox forwarded messages look like:
----------------
```
John Doe
Call: 123-1234 email: <bs@fake.com>
Begin forwarded message:
On Tuesday, Feb 17, 2015 at 9:52 AM, Jizzle Wizzle <jswizzle@pizzle.com>, wrote:
```
