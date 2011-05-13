Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22668 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1EMEWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 00:22:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 21:22:10 -0700
Message-ID: <4DCCB208.1060403@atheros.com> (sfid-20110513_062246_563319_673CCDCF)
Date: Fri, 13 May 2011 09:52:32 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 0/9] ath9k: Add Antenna diversity support for AR9485
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com> <BANLkTinFYwvWSWreUd66DGdsdyo2uU53Hw@mail.gmail.com> <4DBA4417.40604@atheros.com> <20110512165907.GM2490@tuxdriver.com>
In-Reply-To: <20110512165907.GM2490@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 May 2011 10:29 PM, John W. Linville wrote:
> On Fri, Apr 29, 2011 at 10:22:39AM +0530, Mohammed Shafi wrote:
>> On Thursday 28 April 2011 11:42 PM, Luis R. Rodriguez wrote:
>>> On Thu, Apr 28, 2011 at 11:12 AM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com>   wrote:
>>>> On Thu, Apr 28, 2011 at 7:22 AM, Mohammed Shafi Shajakhan
>>>> <mshajakhan@atheros.com>   wrote:
>>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>>
>>>>> *These are purely RFC/RFT patches, none of them are tested.
>>>>>   once tested we will send it as patches.
>>>>> *This patch set adds Antenna diversity support for AR9485, previously
>>>>>   antenna diversity is only supported in AR9285
>>>>> *The basic antenna diversity algorithm remains the same
>>>>> *slight change in the diversity field in eeprom
>>>>> *introduction of main/alt gain table and lna1_lna2 delta fields
>>>>> *initially set LNA1 for main antenna
>>>>> *introduction of diversity group
>>>>> *based on diversity group, fast diversity bias parmaters and
>>>>> lna1_lna2_delta varies
>>>>> *implement an API to take the decision of swapping main/ALT LNA's
>>>>> for AR9485
>>>>> *configure fast diversity bias based on diversity group
>>>> Apart from my one comment:
>>>>
>>>> Reviewed-by: Luis R. Rodriguez<lrodriguez@atheros.com>
>>> Oh yeah and great job on your patch split!
>> thanks!
>>>    Luis
>
> This series was posted RFC -- do you want it merged now?

John, today I will send the complete patch set, I am almost done with 
the testing.

>
