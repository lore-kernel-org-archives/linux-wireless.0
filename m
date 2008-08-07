Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39074 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbYHGPUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:20:40 -0400
Message-ID: <489B12C7.80901@lwfinger.net> (sfid-20080807_172054_323070_9EF8D73F)
Date: Thu, 07 Aug 2008 10:20:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net>	 (sfid-20080807_152154_878184_54C32769) <1218115671.23048.174.camel@johannes.berg>
In-Reply-To: <1218115671.23048.174.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
> 
> Sorry for not catching this earlier, but this looks wrong, the -4 surely
> should be outside the endian conversion?

I thought mixed-endian arithmetic was the latest rage ;). I'll sent V2 right away.

Have a good vacation.

Larry
