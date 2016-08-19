Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:42443 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752904AbcHSGhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 02:37:17 -0400
Date: Thu, 18 Aug 2016 23:36:24 -0700 (PDT)
Message-Id: <20160818.233624.1305767093109968469.davem@davemloft.net> (sfid-20160819_083821_962094_88158FD8)
To: zajec5@gmail.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl, jon.mason@broadcom.com,
        arnd@arndb.de, f.fainelli@gmail.com, tremyfr@gmail.com,
        nbd@openwrt.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] net: bgmac: support Ethernet core on BCM53573
 SoCs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1471467662-18319-1-git-send-email-zajec5@gmail.com>
References: <1471467662-18319-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafa©© Mi©©ecki <zajec5@gmail.com>
Date: Wed, 17 Aug 2016 23:00:30 +0200

> From: Rafa©© Mi©©ecki <rafal@milecki.pl>
> 
> BCM53573 is a new series of Broadcom's SoCs. It's based on ARM and can
> be found in two packages (versions): BCM53573 and BCM47189. It shares
> some code with the Northstar family, but also requires some new quirks.
> 
> First of all there can be up to 2 Ethernet cores on this SoC. If that is
> the case, they are connected to two different switch ports allowing some
> more complex/optimized setups. It seems the second unit doesn't come
> fully configured and requires some IRQ quirk.
> 
> Other than that only the first core is connected to the PHY. For the
> second one we have to register fixed PHY (similarly to the Northstar),
> otherwise generic PHY driver would get some invalid info.
> 
> This has been successfully tested on Tenda AC9 (BCM47189B0).
> 
> Signed-off-by: Rafa©© Mi©©ecki <rafal@milecki.pl>

Applied.
