Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:48919 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab3JDOhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:37:46 -0400
Date: Fri, 4 Oct 2013 16:39:10 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 4/4] rt2x00: rt2800lib: fix VGC
 programming for RT3572 and RT3593
Message-ID: <20131004143910.GD7842@localhost.localdomain> (sfid-20131004_163749_191475_9B81000A)
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
 <1380823243-11149-4-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380823243-11149-4-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 08:00:43PM +0200, Gabor Juhos wrote:
> According to the DPO_RT5572_LinuxSTA_2.6.1.3_20121022
> reference driver, programming of the 'BBP 66' register
> on the RT3572 and RT3593 chipsets must be done via the
> 'rt2800_bbp_write_with_rx_chain' function. This ensures
> that value is correclty set for all RX chains.
> 
> References:
>   RT35xx_ChipAGCAdjust and RT35xx_SetAGCInitValue functions
>   in chips/rt35xx.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
