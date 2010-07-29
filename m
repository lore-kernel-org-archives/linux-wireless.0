Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60110 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0G2RAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 13:00:12 -0400
Date: Thu, 29 Jul 2010 12:58:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: wireless-next-2.6 rebase -- Re: [PATCH 1/3] ath9k: prevent
 calibration during off-channel activity
Message-ID: <20100729165835.GB2424@tuxdriver.com>
References: <1280339151-37084-1-git-send-email-nbd@openwrt.org>
 <AANLkTimZ8zTZWDcXwr7Hu2FT=gDPeCiiUFXcBmpYpp7M@mail.gmail.com>
 <4C509C65.4020305@openwrt.org>
 <AANLkTimqsXoynA2CPJ1tFmj6wUetztDUJ3iKCpQHJKCe@mail.gmail.com>
 <4C50AEF4.4060905@openwrt.org>
 <AANLkTin+sPu45teiAiePPWdBp3huffds3v_uzJBtKmLO@mail.gmail.com>
 <AANLkTikxs8LfQDw4juPRZV3DU1_mX2CMC6vYHYu1n5as@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTikxs8LfQDw4juPRZV3DU1_mX2CMC6vYHYu1n5as@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 03:48:18PM -0700, Luis R. Rodriguez wrote:

> Also without these patches I get 0% packet loss, with the patches
> applied I get some packet loss.

Based on this report, I'm dropping this series from wireless-next-2.6
(requiring a rebase) -- FYI...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
