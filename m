Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45867 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0IRE6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 00:58:01 -0400
Received: by wyf22 with SMTP id 22so2980439wyf.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 21:58:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C6422FB.8040204@lwfinger.net>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
	<AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
	<4C6422FB.8040204@lwfinger.net>
Date: Fri, 17 Sep 2010 21:58:00 -0700
Message-ID: <AANLkTikPm64cko+wricospR-Y0KNAB0JevBGQ0iLc_02@mail.gmail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
From: Paul Thomas <pthomas8589@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gauss Frank <gaussfrank@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jerry chuang <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If your device is one of those that Realtek says works with this driver, and you
> are willing to build a kernel from scratch, I will send you the URL for a git
> tree containing it. That will have to be done privately as I'm still waiting for
> Realtek to approve the copyright statements in the code. It is GPL'ed, so I do
> not expect any difficulties, but their lawyers have to sign off.
>
> Larry

Larry,

I'd be interested in trying your driver version. I don't think it's in
the main tree yet because the change I see for the rtl8192su is on
2010-08-11, but there is a bunch of stuff from Florian from July.

I'm trying to get the rtl8188su chip to work, and more specifically to
get it to work without depending on PCI on arm.

thanks,
Paul
