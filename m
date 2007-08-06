Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([80.12.242.50]:19074 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763851AbXHFKpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 06:45:46 -0400
Received: from smtp23.orange.fr (mwinf2349 [10.232.4.149])
	by mwinf2305.orange.fr (SMTP Server) with ESMTP id 788E61C20C01
	for <linux-wireless@vger.kernel.org>; Mon,  6 Aug 2007 10:36:18 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2349.orange.fr (SMTP Server) with ESMTP id 62E741C0008D
	for <linux-wireless@vger.kernel.org>; Mon,  6 Aug 2007 10:35:36 +0200 (CEST)
In-Reply-To: <1186214124.21957.9.camel@johannes.berg>
References: <200708031737.TAA00882@ifs.emn.fr> <1186214124.21957.9.camel@johannes.berg>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Message-Id: <0E5F2753-6D34-462B-ACBA-CB3A19E30856@wanadoo.fr>
Cc: linux-wireless@vger.kernel.org, Julia Lawall <julia@diku.dk>
From: yoann padioleau <padator@wanadoo.fr>
Subject: Re: [PATCH 13/13] dev->priv to netdev_priv(dev), for drivers/net/wireless
Date: Mon, 6 Aug 2007 10:35:34 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 4 ao=FBt 07, at 09:55, Johannes Berg wrote:

> On Fri, 2007-08-03 at 19:37 +0200, Yoann Padioleau wrote:
>
>> Here is an excerpt of the semantic patch that performs the =20
>> transformation
>
> Out of curiosity, what is that "semantic patch" stuff? Is there =20
> actually
> a tool that applies changes defined in that way?

Yes there is. See www.emn.fr/x-info/coccinelle
This tool is called spatch.

>
> johannes


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
