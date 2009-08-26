Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:30629 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZHZXLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 19:11:35 -0400
Received: by qw-out-2122.google.com with SMTP id 8so111942qwh.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 16:11:36 -0700 (PDT)
Message-ID: <4A95C128.5000405@gmail.com>
Date: Wed, 26 Aug 2009 19:11:36 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
 	enabled
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>	 <4A94B01E.9040309@gmail.com> <4A94C3E9.6070409@lwfinger.net>	 <4A95AA64.20502@gmail.com> <3ace41890908261538s6818b56ax56cca5af18398dbc@mail.gmail.com>
In-Reply-To: <3ace41890908261538s6818b56ax56cca5af18398dbc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Wed, Aug 26, 2009 at 10:34 PM, Richard Farina<sidhayn@gmail.com> wrote:
>
>   
>> I apologize if you thought there was an accusation here, that certainly was
>> not my intention. With all due respect assuming that I'm
>> a jerk is neither safe nor polite.  In your original patch for this I find
>> the following text:
>>     
>
>   
>> Yes, I realize that, which is why I said the "bug is still alive" not "the
>> patch is not applied".  I even went out of my way to describe how the
>> testing was different...
>>     
>
> While I thought Larry's reply was a bit brief, I looked back on the
> thread and I think I am on Larry's side. All you mentioned was that
> you had a crash on unplug, and then you automatically assume that it
> is because the most recent crash-related fix (which Larry kindly made)
> did not work. You have no proof that your problem is even the same as
> what the fix tried to solve. You did not try to go back to a non-LED
> enabled compat-wireless, for example.
>
> To be honest, I think you 'went out of your way' to try to pin your
> problem on one of the developers, so that your problem is guaranteed
> to receive attention. That's not very fair...
>
> That said, I think this thread has gone on long enough - all that
> happened is that (1) you had a crash on unplug, (2) you tried to pin
> it on Larry, (3) many people has checked and verified that what Larry
> did went in, (4) we still don't know whether your crash is related to
> the LED change or not.
>
> Since we still don't know whether your crash is related to any
> LED-related change or not, this thread is not going well.
>
>   
I accept your criticism.  I should have been more clear.  This happens 
only when CONFIG_RTL8187_LEDS=y is set.

I'm not trying to "pin" the bug on Larry claiming it is his fault, I'm 
merely stating that I am experiencing a problem that looks extremely 
similar to what he described when he pushed the mentioned patch.

Again, I'm not trying to point my finger blaming someone, I'm trying to 
help fix a problem.  I am traveling for the next few days, when I get 
home to my camera I hope you are all calm enough to help me troubleshoot 
this bug so we can find a solution instead of accusing each other of 
accusing each other.

My apologies for any perceived insults against anyone, seriously, that's 
not my goal here.


-Rick
