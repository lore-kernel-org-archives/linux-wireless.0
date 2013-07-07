Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:30110 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3GGOMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:12:48 -0400
Date: Sun, 7 Jul 2013 16:15:33 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 11/20] rt2x00: rt2800lib: hardcode TX
 mixer gain values for RT3593
Message-ID: <20130707141533.GG2073@localhost.localdomain> (sfid-20130707_161250_448073_E2606FF8)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-12-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-12-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:50AM +0200, Gabor Juhos wrote:
> The reference code uses hardcoded zero TX mixer gain value
> for RT3593. Do the same in the rt2x00 driver.
> 
> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> Reference:
>   NICReadEEPROMParameters in common/rtmp_init.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
