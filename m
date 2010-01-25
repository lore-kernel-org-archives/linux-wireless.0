Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27741 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0AYOBN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 09:01:13 -0500
Subject: Re: [PATCH] ath9k: fix eeprom INI values override for 2GHz-only
 cards
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, jorge@dti2.net,
	Sujith <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B5B4832.2020800@openwrt.org>
References: <4B5B4832.2020800@openwrt.org>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 09:00:56 -0500
Message-Id: <1264428056.2868.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-01-23 at 20:04 +0100, Felix Fietkau wrote:
> Among other changes, this commit:
> 
>    commit 06d0f0663e11cab4ec5f2c143a118d71a12fbbe9
>    Author: Sujith <Sujith.Manoharan@atheros.com>
>    Date:   Thu Feb 12 10:06:45 2009 +0530
> 
>    ath9k: Enable Fractional N mode
> 
> changed the hw attach code to fix up initialization values only for
> dual band devices, however the commit message did not give a reason as
> to why this would be useful or necessary.
> 
> According to tests by Jorge Boncompte, this breaks at least some 
> 2GHz-only cards, so the code should be changed back to the
> unconditional INI fixup.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Jorge Boncompte <jorge@dti2.net>
> Cc: stable@kernel.org

Tested-by: Pavel Roskin <proski@gnu.org>

Tested on Ubiquiti SR71-15 and Ubiquiti SR71-12.

-- 
Regards,
Pavel Roskin
