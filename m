Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50692 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0LOFvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 00:51:48 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 21:51:33 -0800
Message-ID: <4D085761.2020203@atheros.com>
Date: Wed, 15 Dec 2010 11:21:29 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k: Make PM-QOS value as user configurable
References: <1292312908-6182-1-git-send-email-mshajakhan@atheros.com> <20101214162513.GC6190@tux>
In-Reply-To: <20101214162513.GC6190@tux>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 December 2010 09:55 PM, Luis Rodriguez wrote:
> On Mon, Dec 13, 2010 at 11:48:28PM -0800, Mohammed Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> This patch allows the pm-qos value to be user configurable by making it as
>> a module parameter.This will help our customers to configure the pm-qos
>> value according to the effect in throughput due to the DMA latency problem
>> which was observed in Intel Pinetrail platforms.
>> 	The tested value of '55' will be filled as the default
>> pm-qos-value incase the user does not specifies pm-qos value as a
>> module parameter.
>> example usage: sudo modprobe ath9k pmqos=65
>>      
> Where is this documented though? Can you please add some
>
> /*
>   * some good docs
>   */
>
> of some sort as a followup patch? Thanks!
>    
Ok sure.
>    Luis
> .
>
>    
