Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:31179 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYI1RS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 13:18:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1792536wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 10:18:57 -0700 (PDT)
Message-ID: <40f31dec0809281018l6a2fdacwf03ddf0f2876c1a2@mail.gmail.com> (sfid-20080928_191903_714447_1649ED75)
Date: Sun, 28 Sep 2008 20:18:57 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Peter Chant" <pete@petezilla.co.uk>
Subject: Re: SMC wireless card, unknown Atheros/Accton chipset?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809281734.01027.pete@petezilla.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200809281734.01027.pete@petezilla.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/28 Peter Chant <pete@petezilla.co.uk>:
> Chaps,
>
> hope this is the right place.  I have a SMCWPCI-G2 EU wireless card (PCI) that
> does not seem to be recognised by the ath5k driver.  It is a 802.11g card but
> I tried the ath9k driver for luck, that did not work nor did the madwifi
> drivers.
>
> Output from lspci -v:
>
> 00:0b.0 Ethernet controller: Atheros Communications Inc. Unknown device 001d
> (rev 01)
>        Subsystem: Accton Technology Corporation Unknown device b203
>        Flags: bus master, medium devsel, latency 32, IRQ 5
>        Memory at e2010000 (32-bit, non-prefetchable) [size=64K]
>        Capabilities: [44] Power Management version 2
>
>
> Thoughts?
>
> Pete
>


It's a 2417, i've already posted a patch that adds support for this
but didn't make it on wireless-testing yet.

I'll post some new patches ASAP ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
