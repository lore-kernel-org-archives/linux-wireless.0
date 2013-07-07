Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:7230 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3GGOi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:38:56 -0400
Date: Sun, 7 Jul 2013 16:41:42 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 20/20] rt2x00: rt2800usb: add USB
 device ID for Linksys AE3000
Message-ID: <20130707144142.GT2073@localhost.localdomain> (sfid-20130707_163858_427617_C19A0624)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-21-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-21-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:59AM +0200, Gabor Juhos wrote:
> The Linksys AE3000 device is based on the RT3573
> chipset. The support for this chipset is available
> already, and the AE3000 device works with the driver.
> 
> Only managed mode works correctly at the moment,
> for AP mode additional changes are needed in the
> driver.
> 
> Also add a new RT2800USB_RT3573 Kconfig option and
> only enable support for RT3573 based devices if
> that is enabled.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
