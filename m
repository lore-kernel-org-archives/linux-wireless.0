Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:60387 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbCLNHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:07:48 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>, <crlo@marvell.com>,
	<pchen@marvell.com>, <szli@marvell.com>, <nishants@marvell.com>
Subject: Re: [PATCH 3/9] mwifiex: enhance SD8897 MP aggregation limits
References: <1426180920-10567-1-git-send-email-patila@marvell.com>
	<1426180920-10567-4-git-send-email-patila@marvell.com>
Date: Thu, 12 Mar 2015 14:07:37 +0100
In-Reply-To: <1426180920-10567-4-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Thu, 12 Mar 2015 22:51:54 +0530")
Message-ID: <87bnjy2wkm.fsf@nemi.mork.no> (sfid-20150312_140753_631660_62E7F635)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
> index c636944..5a23bd0 100644
> --- a/drivers/net/wireless/mwifiex/sdio.h
> +++ b/drivers/net/wireless/mwifiex/sdio.h
> @@ -67,6 +67,7 @@
>  
>  #define MWIFIEX_MP_AGGR_BUF_SIZE_16K	(16384)
>  #define MWIFIEX_MP_AGGR_BUF_SIZE_32K	(32768)
> +#define MWIFIEX_MP_AGGR_BUF_SIZE_64K    (65280)

The first two macros are clearly matching their 16K and 32K names, but
the 64K one is not.  Care to add a comment explaining where the missing
256 bytes went?


Bjørn (always curious about surprising numbers :-)
