Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:25535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZAJNQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 08:16:50 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3619299fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 05:16:48 -0800 (PST)
Message-ID: <3ace41890901100516mc2e1ee1h42c4f67b552f7d73@mail.gmail.com> (sfid-20090110_141654_429223_52FF3905)
Date: Sat, 10 Jan 2009 13:16:48 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: lmage11@twcny.rr.com
Subject: Re: Help debugging unexpected disassociations?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090110021351.MHLV4.64591.root@hrndva-web24-z02>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090110021351.MHLV4.64591.root@hrndva-web24-z02>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 2:13 AM,  <lmage11@twcny.rr.com> wrote:
<snipped>
>> Also, it is always useful to quote versions of relevant software -
>> what version of wpa_supplicant, and networkmanager you are using; or
>> even what distribution you are using, and hardware (64-bit, 32-bit).
>> You have written 3 times and added no new info.
>
> You need only ask. :)

That info should have been in your first post, or the 2nd...
And you still have not answered one: what distro - that alone would
have answered or at least hinted at most of the software versions,
etc. 'read my mind'... you are the person asking for help, why do you
expect others to *chase after you* for info? Most people won't bother.

> I am using wpa_supplicant 0.5.7. I am aware that this is a really old version,
> and I can try updating it if you think that would make a difference. I am running
> on a Thinkpad T61, which is 64-bit. I think I already said which chip I'm using,
> but I'll say it again. It's an IWL4965.

Now we are getting somewhere - and my first reply did ask you to run
wpa_supplicant in the foreground.
Even for the 0.5.x series, 0.5.10 is current... and most people are
using 0.6.x . wpa_supplicant (not the driver) is responsible for
encryption and authentication, and you had a deauthentication problem.
Hello, anybody home??!!

So, as you yourself suggested, you should update. And while you are at
it, read wpa_supplicant's doc, and work out the debug options and what
I meant by 'run it in the foreground'.
