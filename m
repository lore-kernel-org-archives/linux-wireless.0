Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59802 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1CUO1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:27:51 -0400
Received: by qwk3 with SMTP id 3so4170097qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:27:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110321140505.GA7321@kroah.com>
References: <20110319214234.GA5152@kroah.com>
	<1300573336.11949.25.camel@maggie>
	<20110319234524.GA7493@kroah.com>
	<op.vsmyhmei3ri7v4@arend-laptop>
	<20110320145421.GA13962@kroah.com>
	<op.vsnd1a1i3ri7v4@arend-laptop>
	<20110320162200.GA17030@kroah.com>
	<op.vsng7q1j3ri7v4@arend-laptop>
	<20110320185216.GD19375@kroah.com>
	<AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
	<20110321140505.GA7321@kroah.com>
Date: Mon, 21 Mar 2011 15:27:49 +0100
Message-ID: <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/21 Greg KH <greg@kroah.com>:
> On Mon, Mar 21, 2011 at 11:12:55AM +0100, Rafał Miłecki wrote:
>> Sorry, but you seem to be deaf to my and George's comments.
>
> Me?
>
>> What's wrong with that?
>
> What's wrong with what?  You provided no context in this message, so I
> have absolutely no idea what you are referring to.
>
> totally confused,

Did you receive two following e-mails (in this thread):
1) From: Rafał Miłecki <zajec5@gmail.com>
Date: 20 03 2011 10:55
2) From: George Kashperko <george@znau.edu.ua>
Date: 20 03 2011 14:07
?

The case is, we discussed ssb/ai driver layout few days ago. George
shared idea of layout I agree with, nobody shared any objections. If
everything goes fine, we should have nicely modularized driver/project
supporting Broadcom's buses.

In this situation I'm not really interested is simple ai driver
stripped from brcm80211. According to me, it would led to harder
maintenance and harder implementation of support for such a driver in
b43.

-- 
Rafał
