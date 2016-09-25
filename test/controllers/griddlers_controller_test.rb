require 'test_helper'

class GriddlersControllerTest < ActionController::TestCase
  
  setup do
    @controller = Griddler::EmailsController.new
  end

  test "should receive new email from user to begin loop" do
    assert_difference('Email.count', 2) do
      spammer_email = "new-spammer@example.com"
      email_params = {
        headers: 'Received: by 127.0.0.1 with SMTP...',
        to: 'John Turing <sp@mlooper.com>',
        from: 'Popeye Sailor-Man <popeye@example.com>',
        subject: 'hello there',
        text: "—\n\nMLooper\n\nJohn Turing, Partner\n\nwww.MLooperco.com | --\n\n---------- Forwarded message ----------\nFrom: \"Greg Cutler\" <#{spammer_email}>\nDate: Tue, Jul 7, 2015 at 5:56 PM\nSubject: Grow with US!\nTo: \"bw@MLooperco.com\" <bw@MLooperco.com>\n\n> Hi John,\n> I know  you're  busy, but wanted  to offer a brief introduction to our services and provide my contact information.  Here are a few of our bullet points. \n> For 15 years we have been working with agencies to: \n> •  Expand Service Off",
        html: "—\n\nMLooper\n\nJohn Turing, Partner\n\nwww.MLooperco.com | --\n\n---------- Forwarded message ----------\nFrom: \"Greg Cutler\" <#{spammer_email}>\nDate: Tue, Jul 7, 2015 at 5:56 PM\nSubject: Grow with US!\nTo: \"bw@MLooperco.com\" <bw@MLooperco.com>\n\n>",
        charsets: '{"to":"UTF-8","html":"ISO-8859-1","subject":"UTF-8","from":"UTF-8","text":"ISO-8859-1"}',
        SPF: "pass"
      }  
      post :create, email_params
      assert_response :success
    end
  end

  test "should accept email from spammer and continue loop" do
    assert_difference('Email.count', 2) do
      spammer_email = "spammer@example.com"
      email_params = {
        headers: 'Received: by 127.0.0.1 with SMTP...',
        to: 'John Turing <john@mlooper.com>',
        from: 'Spammer <spammer@example.com>',
        subject: 'hello there',
        text: "—\n\nMLooper\n\nJohn Turing, Partner\n\nwww.MLooperco.com | --\n\n---------- Forwarded message ----------\nFrom: \"Greg Cutler\" <#{spammer_email}>\nDate: Tue, Jul 7, 2015 at 5:56 PM\nSubject: Grow with US!\nTo: \"bw@MLooperco.com\" <bw@MLooperco.com>\n\n> Hi John,\n> I know  you're  busy, but wanted  to offer a brief introduction to our services and provide my contact information.  Here are a few of our bullet points. \n> For 15 years we have been working with agencies to: \n> •  Expand Service Off",
        html: "—\n\nMLooper\n\nJohn Turing, Partner\n\nwww.MLooperco.com | --\n\n---------- Forwarded message ----------\nFrom: \"Greg Cutler\" <#{spammer_email}>\nDate: Tue, Jul 7, 2015 at 5:56 PM\nSubject: Grow with US!\nTo: \"bw@MLooperco.com\" <bw@MLooperco.com>\n\n>",
        charsets: '{"to":"UTF-8","html":"ISO-8859-1","subject":"UTF-8","from":"UTF-8","text":"ISO-8859-1"}',
        SPF: "pass"
      }  
      post :create, email_params
      assert_response :success
    end
  end

  test "should handle when there is no to address" do
    assert_difference('Email.count', 2) do
      email_params = {
        from: "\"sarah manes\" <sarahstephens81@yahoo.fr>",
        attachments: "0", 
        to: "",
        text: "\r\nDearest\r\nNice to communicate with  you. My name is Sarah Stephense from France. l am \r\n29 years old. l really need your assistance. My husband dead two years ago \r\nand the family members wants to kill me and my children and seat on the \r\ninheritance he left for us with bank here  l am now in a hiding with my kids \r\nand the documents of inheritance is with us. please help us to have this \r\nfund transferred to your country and we will fly to join you.  i will \r\nAttached  my picture and that of my children to you .\r\nl will be waiting for your reply.\r\nSarah Stephense\n", 
        envelope: {
          to: ["john@mlooper.com"],
          from: "sarahmanes@y7.net"
        },
        headers: "Received: by mx0035p1mdw1.sendgrid.net with SMTP id Ih2eB5m3An Mon, 26 Oct 2015 12:57:53 +0000 (UTC)\nReceived: from wm.y7.com (ns76.y.am [64.65.60.22]) by mx0035p1mdw1.sendgrid.net (Postfix) with ESMTP id 849DF740BD6 for <john@mlooper.com>; Mon, 26 Oct 2015 12:57:52 +0000 (UTC)\nReceived: from [154.68.5.28] (account sarahmanes@y7.net) by y7.net (CommuniGate Pro WEBUSER 6.1c2) with HTTP id 79420356; Mon, 26 Oct 2015 21:57:51 +0900\nFrom: \"sarah manes\" <sarahstephens81@yahoo.fr>\nSubject:  Dearest\nX-Mailer: CommuniGate Pro WebUser v6.1c2\nDate: Mon, 26 Oct 2015 21:57:51 +0900\nMessage-ID: <web-79420362@wm.y7.com>\nMIME-Version: 1.0\nContent-Type: text/plain;charset=iso-2022-jp; format=\"flowed\"\nContent-Transfer-Encoding: 7bit\n", 
        sender_ip: "64.65.60.22",
        charsets: '{"to":"UTF-8","html":"ISO-8859-1","subject":"UTF-8","from":"UTF-8","text":"ISO-8859-1"}',
        SPF: "pass",
        dkim: "none",
        subject: "Dearest"
      }
      post :create, email_params
      assert_response :success
    end
  end
  
  test "parse out the spammers email" do
    assert_difference('Email.count', 2) do
      email_params = {
        from: "Brian winston <bw@example.com>", 
        attachments: "0", 
        to: "\"sp@mlooper.com\" <sp@mlooper.com>", 
        text: "---------- Forwarded message ---------\r\nFrom: Approvals <Approvals@mophye.com>\r\nDate: Sat, Oct 31, 2015 at 7:07 PM\r\nSubject: Youve Been Accepted by Whos_Who\r\nTo: <bw@example.com>\r\n\r\n\r\nYou were recently chosen as a potential candidate to represent your\r\nprofessional community in the 2015 Edition of Whos Who. The premier\r\nnetworking organization for distinguished professionals.\r\n\r\n\r\nOnce finalized, your listing will share registry space with\r\ntens-of-thousands of fellow accomplished individuals across the globe, each\r\nrepresenting accomplishment within their own geographical area.\r\n\r\n\r\nTo verify your profile and accept the candidacy, click here.\r\n\r\n\r\nOn behalf of our Committee I salute your achievement and welcome you to our\r\norganization.\r\n\r\nWarm_Regards,\r\n\r\n\r\nApprovals Department\r\n\r\n\r\nStop receiving emails from us\r\n\r\n\r\nfc4405105b10197693e66f3b6ef6c7d8 ule. The apparent scale of unrest in\r\nZhanaozen will come as a shock to Nazarbayevs government, which has also\r\nbeen combating an unprecedented surge in radical Islamist-inspired violence\r\nin recent months.\n", 
        envelope: {to:["sp@mlooper.com"],from:"bw@example.com"},
        headers: "Received: by mx0045p1mdw1.sendgrid.net with SMTP id OAQvMUd8NV Sun, 01 Nov 2015 18:10:43 +0000 (UTC)\nReceived: from mail-ig0-f175.google.com (mail-ig0-f175.google.com [209.85.213.175]) by mx0045p1mdw1.sendgrid.net (Postfix) with ESMTPS id 8348BA01E4E for <sp@mlooper.com>; Sun,  1 Nov 2015 18:10:43 +0000 (UTC)\nReceived: by igpw7 with SMTP id w7so36741853igp.1 for <sp@mlooper.com>; Sun, 01 Nov 2015 10:10:42 -0800 (PST)\nDKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=example_com.20150623.gappssmtp.com; s=20150623; h=mime-version:references:in-reply-to:from:date:message-id:subject:to :content-type; bh=goe4f+xNs0ed5vkyCas8qARe5GpjppwUYHU7JgMUU+U=; b=kFuPureMAu278lBUt1i2RaxgmdmREapOLdytYcgHnfAtAiyAWk8/CB3oWf1EOMima7 eed2slAK8cpDJgZrm0Ekm932ObDvrHjA1+ETB9gTN5cX4LcZ20camU+g0oW+2m1vEV+W w2tH8AOA9kuF1vlbFZ0v3lr0roUaSIQ1FhsacOCMIa5cBsmC+9A0W3b8ErNBpGkrvizH tRDPywqk/nzLdLHv49h4gDFaX106w0oO5PG3Rc2vYPXia7SKS4xPkD/BilTFlt+HL2GR oYS+yaxxWv3Mga0hqEH8D5DyoNjd54m0Vlo9iNIqtnYzv8P3ylbTil2Dt1MSQrGB77qH H0bA==\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20130820; h=x-gm-message-state:mime-version:references:in-reply-to:from:date :message-id:subject:to:content-type; bh=goe4f+xNs0ed5vkyCas8qARe5GpjppwUYHU7JgMUU+U=; b=Gpx1jCl3pTZcK0exP01ykYqxgdsrePNm19sZV2Fl1mjTboCOEeUiQkk6htvKz5ytzr bOQ1Ol4NHwfQcYStzF4SVRngPW2oIXZh3GIBiVqEL1CitRfCa1sQ7YZ0W7riJL8L4EYZ 1CcpWbFAhppyxV0p+fVlCnN/K9QQeet7/07YTSh3m2p4qMCKmpopLNOJhb23+5k0wZ+m g672raPYk7Sl43BWATITH26x5nDQ8Pf9Qey1HBzmtR8cU+ILQc63m6YS66bBucEZIgGl GIa4cghfemBqURHRVVGJ49XoDEFQa64kRiXe3I0d3h3wAO0wgszUOdm35VTzcZ8ICFNZ P2rw==\nX-Gm-Message-State: ALoCoQliR+FWaKEeXX/jiS2zD8KLPGQmsTMdjuuDXKh6scsBahBMi+iPBrs7guq5HAUFbf4belXP\nX-Received: by 10.50.79.232 with SMTP id m8mr7272938igx.22.1446401442629; Sun, 01 Nov 2015 10:10:42 -0800 (PST)\nMIME-Version: 1.0\nReferences: <7262965939431672636285272@udg4x.mophye.com>\nIn-Reply-To: <7262965939431672636285272@udg4x.mophye.com>\nFrom: Brian winston <bw@example.com>\nDate: Sun, 01 Nov 2015 18:10:32 +0000\nMessage-ID: <CAKjmn3pUag=dxuVgCHFftTOpDDHjDL4FF=+OOZX9Gtk10Sureg@mail.gmail.com>\nSubject: Fwd: Youve Been Accepted by Whos_Who\nTo: \"sp@mlooper.com\" <sp@mlooper.com>\nContent-Type: multipart/alternative; boundary=089e013a060630eaf205237e947e\n", 
        html: "<div dir=\"ltr\"><br><br><div class=\"gmail_quote\"><div dir=\"ltr\">---------- Forwarded message ---------<br>From: Approvals &lt;<a href=\"mailto:Approvals@mophye.com\">Approvals@mophye.com</a>&gt;<br>Date: Sat, Oct 31, 2015 at 7:07 PM<br>Subject: You&#39;ve Been Accepted by Who&#39;s_Who<br>To:  &lt;<a href=\"mailto:bw@example.com\">bw@example.com</a>&gt;<br></div><br><br>\n<div>\n <table width=\"98%\" border=\"0\" cellspacing=\"1\" cellpadding=\"1\">\n <tbody>\n <tr>\n <td valign=\"top\" style=\"text-align:left\" colspan=\"2\">\nYou were recently chosen as a potential candidate to represent your professional community in the 2015 Edition of Who&#39;s Who. The premier networking organization for distinguished professionals.\n<p><br>\nOnce finalized, your listing will share registry space with tens-of-thousands of fellow accomplished individuals across the globe, each representing accomplishment within their own geographical area.\n</p><p><br>\nTo verify your profile and accept the candidacy, <a>click here.</a>\n</p><p><br>\n\nOn behalf of our Committee I salute your achievement and welcome you to our organization.\n<br></p><p>\nWarm_Regards,\n</p><p><br>\nApprovals Department<br>\n</p><p></p><p></p><p></p><p></p></td>\n</tr>\n</tbody></table>\n<p><br>\n<a>Stop receiving emails from us</a></p><p><br>\n  <span style=\"overflow:hidden;float:left;line-height:0px\">\nfc4405105b10197693e66f3b6ef6c7d8\nule. The apparent scale of unrest in Zhanaozen will come as a \nshock to Nazarbayev&#39;s government, which has also been combating an unprecedented surge \nin radical Islamist-inspired violence in recent months.\n \n</span>\n\n</p><p></p></div>\n</div></div>\n", 
        action: "create", 
        sender_ip: "209.85.213.175", 
        SPF: "none", 
        subject: "Fwd: You've Been Accepted by Who's_Who"
      }
      post :create, email_params
      assert_response :success
    end
  end

end