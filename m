Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:42803 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3GGONk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:13:40 -0400
Date: Sun, 7 Jul 2013 16:16:25 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 07/20] rt2x00: rt2800lib: fix antenna
 configuration for RT3593
Message-ID: <20130707141625.GI2073@localhost.localdomain> (sfid-20130707_161342_872331_A3BDC133)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-8-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-8-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:46AM +0200, Gabor Juhos wrote:
> On the RT3593 chipset, BBP register 86 must be
> configured by different values based on the RX
> antenna numbers.
> 
> Configure this register from the 'rt2800_config_ant'
> function.
> 
> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> Reference:
>   RT3593_CONFIG_SET_BY_ANTENNA in include/chip/rt3593.h
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
