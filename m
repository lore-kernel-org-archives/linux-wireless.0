Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:10025 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3GGORT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:17:19 -0400
Date: Sun, 7 Jul 2013 16:20:05 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 09/20] rt2x00: rt2800lib: fix default
 TX power values for RT3593
Message-ID: <20130707142005.GK2073@localhost.localdomain> (sfid-20130707_161721_994962_6C974E32)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-10-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-10-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:48AM +0200, Gabor Juhos wrote:
> The TX power values in the EEPROM are using
> a different format for the RT3593 chip. The
> default TX power value uses bits 0..4 only.
> Bits 5..8 contains value for fine grained
> power control. Additionally, the lower and
> upper limits of the TX power values are the
> same for both bands.
> 
> Improve the rt2800_txpower_to_dev function,
> in order to compute the correct default power
> values for the RT3593 chip as well.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
