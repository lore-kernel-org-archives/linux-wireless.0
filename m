Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60768 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZAFJln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 04:41:43 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 01:41:43 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18787.9876.841701.283397@gargle.gargle.HOWL> (sfid-20090106_104157_191893_765758C0)
Date: Tue, 6 Jan 2009 15:08:28 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 08/12] ath9k: get EEPROM contents from platform data on
 AHB bus
In-Reply-To: <4961FBD1.4030103@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
	<1230990262-22923-9-git-send-email-juhosg@openwrt.org>
	<18785.57618.47120.669270@gargle.gargle.HOWL>
	<4961FBD1.4030103@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> > Also, after addressing Christopher's comments, I don't think too many
> > bus specific routines would remain. In that case would it be reasonable
> > to just have a single file (bus.c, with appropriate ifdefs), instead
> > of pci.c and ahb.c ?
> 
> We will have 3 of them actually (read_cachesize, read_eeprom, cleanup), but here
> is the whole {pci,platform}_driver specific stuff. Of course we can move all of
> this into one file, but i would like to avoid the unnecessary ifdefs where it is
> possible. Apart from this, if we will put the PCI and AHB stuff into one file,
> we could put it into main.c simply.

Your choice really, it doesn't matter much anyway. :)

Sujith
