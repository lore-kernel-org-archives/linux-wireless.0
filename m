Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:26572 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3HTUMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 16:12:44 -0400
Date: Tue, 20 Aug 2013 22:13:03 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800lib: introduce
 rt2800_get_txwi_rxwi_size helper
Message-ID: <20130820201303.GA2233@localhost.localdomain> (sfid-20130820_221247_880151_C18F3104)
References: <1376641410-20798-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376641410-20798-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 16, 2013 at 10:23:29AM +0200, Gabor Juhos wrote:
> The rt2800pci driver uses the same [RT]XWI size
> for all chipsets, however some chips requires
> different values.
> 
> The size of the [RT]XWI structures is a constant
> value for a given chipset and it does not depend
> on the underlying interface. Add a helper function
> which returns the correct values for the actual
> chipset and use the new helper both in the rt2800usb
> and in the rt2800pci drivers. This ensures that both
> drivers are using the correct values.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

