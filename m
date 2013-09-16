Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52136 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234Ab3IPV06 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 17:26:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Jingoo Han <jg1.han@samsung.com>,
	"'John W. Linville'" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"'David Miller'" <davem@davemloft.net>
Date: Mon, 16 Sep 2013 14:26:44 -0700
Subject: RE: [PATCH] mwifiex: Remove casting the return value which is a
 void pointer
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C584A5@SC-VEXCH1.marvell.com> (sfid-20130916_232701_292022_EF921505)
References: <004d01cead1d$3058dcf0$910a96d0$%han@samsung.com>
In-Reply-To: <004d01cead1d$3058dcf0$910a96d0$%han@samsung.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jingoo,

Thanks for the patch.

> Casting the return value which is a void pointer is redundant.
> The conversion from void pointer to any other pointer type is
> guaranteed by the C programming language.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/pcie.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

