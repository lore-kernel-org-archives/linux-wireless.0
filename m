Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35633 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbbLQIza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 03:55:30 -0500
Received: by mail-oi0-f49.google.com with SMTP id l9so10455426oia.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 00:55:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150814143229.61440072@north>
References: <20150814081526.GC20192@hackpad.Elisa>
	<20150814143229.61440072@north>
Date: Thu, 17 Dec 2015 09:55:29 +0100
Message-ID: <CACRpkdb9D9107JLLUA1PYcasVze9MF+3jKjkXf2zCRWDUFEBYA@mail.gmail.com> (sfid-20151217_095533_769653_7EF043A0)
Subject: Re: About adding support for MT76x2U to Linux kernel
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>
Cc: =?UTF-8?B?VHVvbWFzIFLDpHPDpG5lbg==?= <tuomasjjrasanen@tjjr.fi>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	tuomasjjrasanen@opinsys.fi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2015 at 2:32 PM, Jakub Kiciński <moorray3@wp.pl> wrote:

> CC: Linus W who was hacking on mt7630e recently.

FWIW I have pushed my git tree here:
https://github.com/linusw/linux-mt7630e

The driver codedrop from Mediatek turned out to be based on
kernel v3.10 so there the patches applied cleanly. I then rebased
that to v3.11 all the way up to v4.3.

Branches are named:
mt7630e-<kernelversion>

That branch does allow me to see access points so it's not
totally worthless, but it doesn't associate or connect so
there is logic missing, and that's where my knowledge of
wireless fell short. It wasn't about git rebasing and simple
C code anymore ... I actually had to know what I was
doing, haha :)

Since then I have not had time to go back and look at it
again.

Yours,
Linus Walleij
