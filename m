Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37046 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1D2EwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:52:16 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:51:49 -0700
Message-ID: <4DBA43FB.6010709@atheros.com> (sfid-20110429_065224_242972_98B1D06E)
Date: Fri, 29 Apr 2011 10:22:11 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 4/9] ath9k_hw: config diversity based on eeprom contents
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <1304000579-5784-5-git-send-email-mshajakhan@atheros.com> <20110428173944.GB29252@tux>
In-Reply-To: <20110428173944.GB29252@tux>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 April 2011 11:09 PM, Luis Rodriguez wrote:
> On Thu, Apr 28, 2011 at 07:22:54AM -0700, Mohammed Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> * enable LNA-diversity, fast-diversity based on the value read from
>>    EEPROM content
>> * if antenna diversity/combining is supported set LNA1 for the main
>>    antenna and LNA2 for the alternate antenna based on the new diversity
>>    algorithm
>>      
> The commit log does not mention this is specifically only for
> AR9485. Adding this can help reviewers / distributions.
>    
Ok Luis, I will address that.

thanks,
shafi
>    Luis
> .
>
>    
