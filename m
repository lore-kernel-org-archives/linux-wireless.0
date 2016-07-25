Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:39988 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcGYTcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 15:32:15 -0400
Message-ID: <57966931.4020505@bfs.de> (sfid-20160725_213239_610981_42B8EF06)
Date: Mon, 25 Jul 2016 21:32:01 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
CC: SF Markus Elfring <elfring@users.sourceforge.net>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: wilc1000: Reduce scope for a few variables
 in mac_ioctl()
References: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>
In-Reply-To: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 25.07.2016 21:17, schrieb Lino Sanfilippo:
>>  
>> -			if (strncasecmp(buff, "RSSI", length) == 0) {
>> +			if (strncasecmp(buff, "RSSI", 0) == 0) {
>> +				s8 rssi;
>> +
> 
> Um, please think a second about if it makes any sense at all to compare 
> zero chars of two strings.
> 
> Lino

also:
the switch has only one case and default.

re,
 wh
