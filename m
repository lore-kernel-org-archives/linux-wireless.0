Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63897 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab1BNEbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 23:31:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 20:30:50 -0800
Message-ID: <4D58B00A.2060309@atheros.com>
Date: Mon, 14 Feb 2011 10:01:06 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: make use of slot time macros
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com> <4D553107.3020402@openwrt.org>
In-Reply-To: <4D553107.3020402@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 February 2011 06:22 PM, Felix Fietkau wrote:
> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> Instead of using raw numbers to assign slot time it would be better to
>> make use of predefined slot time macros
>>      
> How does this make it better?
>    
There is a macro already available, so why not make use of it and 
improve the readability of the code. Please correct me if I am wrong.
> - Felix
> .
>
>    
