Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:18083 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3JDOZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:25:40 -0400
Date: Fri, 4 Oct 2013 16:27:03 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 2/4] rt2x00: rt2800lib: fix VGC
 adjustment for RT3572 and RT3593
Message-ID: <20131004142703.GB7842@localhost.localdomain> (sfid-20131004_162543_796799_0CB39D49)
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
 <1380823243-11149-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380823243-11149-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 08:00:41PM +0200, Gabor Juhos wrote:
> The Ralink DPO_RT5572_LinuxSTA_2.6.1.3_20121022
> reference driver uses different RSSI threshold
> and VGC adjustment values for the RT3572 and
> RT3593 chipsets.
> 
> Update the rt2800_link_tuner function to use the
> same values. Also change the comment in the function
> to make it more generic.
> 
> References:
> 
>   RT35xx_ChipAGCAdjust function in chips/rt35xx.c
>   RSSI_FOR_MID_LOW_SENSIBILITY constant in include/chip/rtmp_phy.h
>   RT3593_R66_MID_LOW_SENS_GET macro in include/chip/rt3593.h
>   RT3593_R66_NON_MID_LOW_SEMS_GET macro in include/chips/rt3593.h
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
