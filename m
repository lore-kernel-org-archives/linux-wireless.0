Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:1266 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab1HVOVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 10:21:21 -0400
Message-ID: <4E52638C.8080407@inria.fr> (sfid-20110822_162139_485505_0097D1D2)
Date: Mon, 22 Aug 2011 16:11:24 +0200
From: Pierre Louis Aublin <pierre-louis.aublin@inria.fr>
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Bing Zhao <bzhao@marvell.com>, kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/net/wireless/mwifiex/scan.c: test the just-initialized
 value
References: <1314021636-11528-4-git-send-email-julia@diku.dk>
In-Reply-To: <1314021636-11528-4-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all

On 08/22/2011 04:00 PM, Julia Lawall wrote:
> -	if (!bss_desc) {
> +	if (!beacon_ie) {
>   		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
Shouldn't we also modify the error message, from "failed to alloc 
bss_desc" to "failed to alloc beacon_ie" ?

Sincerely
Pierre Louis Aublin
