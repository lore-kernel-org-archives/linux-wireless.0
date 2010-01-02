Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56740 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0ABQzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:55:08 -0500
Received: by ewy19 with SMTP id 19so5985870ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 08:55:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B3F78ED.4090101@lwfinger.net>
References: <op.u5wyi5dd9lhzdc@linux-g0th.site> <4B3F78ED.4090101@lwfinger.net>
Date: Sat, 2 Jan 2010 17:55:06 +0100
Message-ID: <b170af451001020855v3892909o134636ad1c8f5586@mail.gmail.com>
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2010 17:48 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> Your tabs have been converted to spaces.
>
> Most of my patches are sent using the mail command; however, I can send them
> with Thunderbird using the following steps:

Oh great :| I guess I'll just try mail command.


> I'm not sure how far you have gotten with the code, but I have been working with
> a new driver with version 5.10.56.46. There are a lot of changes from the
> 4.174... that was previously reverse-engineered.

I don't have anything more than posted patches.

What do you suggest about writing next (real) parts? Is that worth
effort basing code on current RE docs? Maybe some parts only, that
didn't change? Or should I just wait for update (is anyone working on
it)?


> To answer your question in a later E-mail. You do not need to conditionalize the
> core revision entry. If the N PHY code is not turned on, the driver will get an
> unsupported PHY message and fail later in an acceptable error.

One more confirmation :) Thanks.


-- 
Rafał
