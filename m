Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:43887 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3JEM7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 08:59:44 -0400
Date: Sat, 5 Oct 2013 15:01:07 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: fix default VGC values
 for RT3572 for the 5GHz band
Message-ID: <20131005130106.GA3106@localhost.localdomain> (sfid-20131005_145950_119541_DC599C4B)
References: <1380917229-13269-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380917229-13269-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 04, 2013 at 10:07:09PM +0200, Gabor Juhos wrote:
> The rt2x00 driver uses 0x22 as a default VGC value
> in VGC adjustment for the RT3572 chipset. In the
> Ralink DPO_RT5572_LinuxSTA_2.6.1.3_20121022 driver,
> this value is only used for initialization. During
> VGC adjustment, the reference driver uses different
> values.
> 
> Update the 'rt2800_get_default_vgc' function to
> synchronize the values with the reference driver.
> Also add the missing AGC initialization code into
> the 'rt2800_config_channel' function.
> 
> References:
>   RT35xx_SetAGCInitValue in chip/rt35xx.c
>   RT35xx_ChipAGCAdjust in chip/rt35xx.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
