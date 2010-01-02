Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42345 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0ABRk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:40:57 -0500
Received: by yxe17 with SMTP id 17so12758071yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 09:40:57 -0800 (PST)
Message-ID: <4B3F8527.3000306@lwfinger.net>
Date: Sat, 02 Jan 2010 11:40:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
References: <op.u5wyi5dd9lhzdc@linux-g0th.site> <4B3F78ED.4090101@lwfinger.net> <b170af451001020855v3892909o134636ad1c8f5586@mail.gmail.com>
In-Reply-To: <b170af451001020855v3892909o134636ad1c8f5586@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2010 10:55 AM, Rafał Miłecki wrote:
> W dniu 2 stycznia 2010 17:48 użytkownik Larry Finger
> <Larry.Finger@lwfinger.net> napisał:
>> Your tabs have been converted to spaces.
>>
>> Most of my patches are sent using the mail command; however, I can send them
>> with Thunderbird using the following steps:
> 
> Oh great :| I guess I'll just try mail command.
> 
> 
>> I'm not sure how far you have gotten with the code, but I have been working with
>> a new driver with version 5.10.56.46. There are a lot of changes from the
>> 4.174... that was previously reverse-engineered.
> 
> I don't have anything more than posted patches.
> 
> What do you suggest about writing next (real) parts? Is that worth
> effort basing code on current RE docs? Maybe some parts only, that
> didn't change? Or should I just wait for update (is anyone working on
> it)?

I have finished the initialization routine found in
http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N. I still have 6 or 8 of the
routines called to prepare and some of the others to check, but you could at
least code the main routine with dummy stubs for the called routines..

You should check with Gabor regarding PHY and radio register names.

Larry
