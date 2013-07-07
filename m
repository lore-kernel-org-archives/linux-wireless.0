Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:60855 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3GGOPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:15:38 -0400
Date: Sun, 7 Jul 2013 16:18:24 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 08/20] rt2x00: rt2800lib: add
 rt2800_txpower_to_dev helper
Message-ID: <20130707141824.GJ2073@localhost.localdomain> (sfid-20130707_161542_280508_68158099)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-9-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-9-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:47AM +0200, Gabor Juhos wrote:
> Introduce a new helper function for converting
> the default TX power values from EEPROM into
> mac80211 values.
> 
> The change improves the readability and it makes
> it easier to add support for other chipsets.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
