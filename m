Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-133-90.gdrpmi.dsl-w.verizon.net ([71.115.133.90]:59006
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLDAn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 19:43:27 -0500
Message-ID: <49372568.2070404@erley.org> (sfid-20081204_014331_402629_2182F689)
Date: Wed, 03 Dec 2008 19:33:44 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
CC: Henning Rogge <hrogge@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Looking for a 802.11n card
References: <200812032129.16740.hrogge@googlemail.com> <45e8e6c40812031609h50926100xfa616a5bdb9be93e@mail.gmail.com>
In-Reply-To: <45e8e6c40812031609h50926100xfa616a5bdb9be93e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Yurovsky wrote:
> There are a number of options listed here:
> http://linuxwireless.org/en/users/Drivers/ath9k#supportedchips
> 
> On Wed, Dec 3, 2008 at 12:29 PM, Henning Rogge <hrogge@googlemail.com> wrote:
>> Hi,
>>
>> I'm looking for a dualband (2,4 Ghz and 5 Ghz) 802.11n card for my desktop,
>> but was unable to find one. Can you suggest a good card for testing 802.11n
>> with Linux ?
>>
>> Henning Rogge
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Specifically:

AR5418+AR5133 [1]
AR5416+AR5133 [1]
AR9160 [2]
AR9280 [3]

Support dual band

[1] http://www.atheros.com/news/xspan.html
[2] http://www.atheros.com/pt/AR9001AP-3NX2.htm
[3] http://www.atheros.com/news/AR9280_AR9281.htm3

Pat
