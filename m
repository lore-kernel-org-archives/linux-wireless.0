Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3384 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYKUDBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 22:01:24 -0500
Date: Thu, 20 Nov 2008 22:00:22 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: Clean up eeprom parsing and add missing calibration data
Message-ID: <20081121030022.GA25726@hash.localnet> (sfid-20081121_040131_364234_69957D66)
References: <49257136.2050902@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49257136.2050902@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 03:16:22PM +0100, Felix Fietkau wrote:
> +
> +	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
> +		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
> +		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);

Can we add the rest here?

+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC2, ee_misc2);
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC3, ee_misc3);
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC4, ee_misc4);
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC5, ee_misc5);

I'm adding CCMP support and it wants to use AR5K_EEPROM_AES_DIS(ee_misc5).

-- 
Bob Copeland %% www.bobcopeland.com

