Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40477 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1GTOsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 10:48:12 -0400
Received: by vxh35 with SMTP id 35so200521vxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 07:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107201536.01392.helmut.schaa@googlemail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<201107201536.01392.helmut.schaa@googlemail.com>
Date: Wed, 20 Jul 2011 18:48:09 +0400
Message-ID: <CAN=pzdKLtB2yz4-OhKL5gzYF0Qm2weAmNAz-0MqdFuooFNYzwQ@mail.gmail.com> (sfid-20110720_164816_973212_26FC75F0)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, correct.

This is how I've discovered it:
At first, I've accidentally found that stable version 2.6.37-4.tar.bz2
does not have this problem, because every later stable version does.
Then I've decided to try other drivers that have similar release
date\archive size.
So eventually I was in the folder
http://www.orbit-lab.org/kernel/compat-wireless-2.6/2010/12/ and tried
the first and the last one. And compat-wireless-2010-12-01.tar.bz2 was
fine, while compat-wireless-2010-12-26.tar.bz2 wasn't.
Then I've tried the middle one, etc. In the end I was certain that
something has changed between 13th and 14th. So since 2010-12-14 the
problem is present.


2011/7/20 Helmut Schaa <helmut.schaa@googlemail.com>:
> Am Mittwoch, 20. Juli 2011 schrieb Stanislav Demakov:
>> I'm using hostapd 0.73 and 1T1R rt2x00 based wireless dongle to create
>> an AP. The problem is that since version
>> compat-wireless-2010-12-14.tar.bz2 802.11n mode is not working
>> properly. In this driver version and all later you've broken
>> something!
>
> So, 2010-12-14 already shows the problem you've described while 2010-12-13
> does not, right?
>
> Helmut
>
