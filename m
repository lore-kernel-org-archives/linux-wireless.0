Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3948 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934146Ab2C3LuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:50:17 -0400
Message-ID: <4F759DE4.6070201@broadcom.com> (sfid-20120330_135021_877689_1664469C)
Date: Fri, 30 Mar 2012 13:49:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat: crc8: undef pr_fmt
References: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2012 01:13 PM, Johannes Berg wrote:
>
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif
>   #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>
>   #include<linux/module.h>

Trivial remark. Not really necessary to do the #ifdef. #undef works fine 
if pr_fmt has not been defined.

Gr. AvS

