Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:13013 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3GGOUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:20:48 -0400
Date: Sun, 7 Jul 2013 16:23:34 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 12/20] rt2x00: rt2x00lib: fix LNA_A[12]
 gain values for RT3593
Message-ID: <20130707142334.GL2073@localhost.localdomain> (sfid-20130707_162051_403723_2CB7DC7B)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-13-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-13-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:51AM +0200, Gabor Juhos wrote:
> The LNA_A[12] gain values are stored at a different
> offset in the EEPROM on RT3593 based devices. However
> the current code unconditionally reads those values
> from the location used by other chipsets.
> 
> Fix the code to use the correct EEPROM offset.
> 
> Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> References:
>   RT3593_EEPROM_RSSI2_OFFSET_ALNAGAIN1_24G_READ in include/chip/rt3593.h
>   RT3593_EEPROM_RSSI2_OFFSET_ALNAGAIN2_5G_READ in include/chip/rt3593.h
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
