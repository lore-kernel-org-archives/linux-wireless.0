Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:16393 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3GGOHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:07:23 -0400
Date: Sun, 7 Jul 2013 16:10:09 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 03/20] rt2x00: rt2800lib: add RFCSR
 register initialization for RT3593
Message-ID: <20130707141009.GC2073@localhost.localdomain> (sfid-20130707_160727_126227_E980FBCA)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-4-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-4-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:42AM +0200, Gabor Juhos wrote:
> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> References:
>   NICInitRT3593RFRegisters in chips/rt3593.c
>   RT3593LoadRFNormalModeSetup in chips/rt3593.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

>  	case RT3390:
>  		rt2800_init_rfcsr_3390(rt2x00dev);
>  		break;
> +	case RT3593:
> +		rt2800_init_rfcsr_3593(rt2x00dev);
> +		break;
>  	case RT3572:
>  		rt2800_init_rfcsr_3572(rt2x00dev);
>  		break;

Nit: RT3572 should be before RT3593.
