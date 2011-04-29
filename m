Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37060 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1D2Ewo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:52:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:52:16 -0700
Message-ID: <4DBA4417.40604@atheros.com> (sfid-20110429_065246_760205_CB6B2712)
Date: Fri, 29 Apr 2011 10:22:39 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 0/9] ath9k: Add Antenna diversity support for AR9485
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com> <BANLkTinFYwvWSWreUd66DGdsdyo2uU53Hw@mail.gmail.com>
In-Reply-To: <BANLkTinFYwvWSWreUd66DGdsdyo2uU53Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 April 2011 11:42 PM, Luis R. Rodriguez wrote:
> On Thu, Apr 28, 2011 at 11:12 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com>  wrote:
>    
>> On Thu, Apr 28, 2011 at 7:22 AM, Mohammed Shafi Shajakhan
>> <mshajakhan@atheros.com>  wrote:
>>      
>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>
>>> *These are purely RFC/RFT patches, none of them are tested.
>>>   once tested we will send it as patches.
>>> *This patch set adds Antenna diversity support for AR9485, previously
>>>   antenna diversity is only supported in AR9285
>>> *The basic antenna diversity algorithm remains the same
>>> *slight change in the diversity field in eeprom
>>> *introduction of main/alt gain table and lna1_lna2 delta fields
>>> *initially set LNA1 for main antenna
>>> *introduction of diversity group
>>> *based on diversity group, fast diversity bias parmaters and
>>> lna1_lna2_delta varies
>>> *implement an API to take the decision of swapping main/ALT LNA's
>>> for AR9485
>>> *configure fast diversity bias based on diversity group
>>>        
>> Apart from my one comment:
>>
>> Reviewed-by: Luis R. Rodriguez<lrodriguez@atheros.com>
>>      
> Oh yeah and great job on your patch split!
>    
thanks!
>    Luis
>    
