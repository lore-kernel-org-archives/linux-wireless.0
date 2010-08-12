Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53149 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083Ab0HLQg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 12:36:29 -0400
Received: by ewy23 with SMTP id 23so779222ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2010 09:36:27 -0700 (PDT)
Message-ID: <4C6422FB.8040204@lwfinger.net>
Date: Thu, 12 Aug 2010 11:36:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gauss Frank <gaussfrank@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jerry chuang <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com> <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
In-Reply-To: <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gauss,

What is the USB ID for your device. The reason I'm asking is that Florian and I
have been working on porting a new vendor driver for the 8192u devices. The plan
is to submit this to staging. At the moment, it has been tested with big- and
little-endian, and 32- and 64-bit systems. Everything is working except for
suspend and resume.

If your device is one of those that Realtek says works with this driver, and you
are willing to build a kernel from scratch, I will send you the URL for a git
tree containing it. That will have to be done privately as I'm still waiting for
Realtek to approve the copyright statements in the code. It is GPL'ed, so I do
not expect any difficulties, but their lawyers have to sign off.

Larry

