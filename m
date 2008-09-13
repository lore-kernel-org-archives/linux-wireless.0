Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56766 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYIMUDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 16:03:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Mike Cui" <cuicui@gmail.com>
Subject: Re: BMC4310 support (03f0:171d)
Date: Sat, 13 Sep 2008 22:03:23 +0200
Cc: "Stefanik =?utf-8?q?G=C3=A1bor?=" <netrolller.3d@gmail.com>,
	"Nadav Kavalerchik" <nadavkav@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com> <69e28c910809121157qaaad7c8w67d626e60e807892@mail.gmail.com> <7c8826910809122011i23587a6bta838f2e0a7c39744@mail.gmail.com>
In-Reply-To: <7c8826910809122011i23587a6bta838f2e0a7c39744@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809132203.24007.mb@bu3sch.de> (sfid-20080913_220359_322140_8EB8A934)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 September 2008 05:11:50 Mike Cui wrote:
> > It is not a "BCM4315", it is a BCM4310. There is no such thing as a
> > BCM4315. Chip ID != PCI ID!
> > Most chip IDs match with their respective PCI IDs, but here are some exceptions:
> > 0x4320 is BCM4306.
> > 0x4315 is BCM4310.
> > 0x4328 is BCM4321.
> > 0x432b is BCM4322.
> 
> Maybe...
> 
> But on the miniPCIe chip itself, there is a sticker that says Broadcom
> 4312. But it's not a BCM4312 either, because BCM4312 actually works...

the numbers printed on the chip package are package IDs. These are
different from chip-ids sometimes. ;)

The only way to find out the chipid really is to load b43 and look
for the message saying "found Broadcom XXXX WLAN".

But still, having a chip with the same chipid and/or package ids doesn't
mean it's the same chip. :)

-- 
Greetings Michael.
