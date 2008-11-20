Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45281 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbYKTS2k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 13:28:40 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 10:28:40 -0800
Message-ID: <4924FC30.7080906@atheros.com> (sfid-20081120_192843_512812_BB32F7E4)
Date: Thu, 20 Nov 2008 11:27:04 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] ath9k: Dont update rate control for every AMPDU
References: <1227160312-5078-1-git-send-email-vasanth@atheros.com>	 (sfid-20081120_192323_892886_92014C1D) <1227205528.3766.29.camel@johannes.berg>
In-Reply-To: <1227205528.3766.29.camel@johannes.berg>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2008-11-20 at 11:21 +0530, Vasanthakumar Thiagarajan wrote:
> 
>> +	u8 update_rc;
> 
>> +	tx_info_priv->update_rc = 0;
> 
>> +			tx_info_priv->update_rc = 1;
> 
> You could use a bool and use false/true, that'd generate exactly the
> same code but might be easier to read. Not that it matters much I guess.
> 
> johannes


Sure, if it improves the readability.

Vasanth
