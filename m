Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:19893 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbcBQB0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 20:26:40 -0500
Subject: Re: drivers/staging/wilc1000/wilc_spi.c won't compile ?
To: David Binderman <dcb314@hotmail.com>,
	"Kim, Leo" <leo.kim@atmel.com>,
	"Shin, Austin" <austin.shin@atmel.com>,
	"Park, Chris" <chris.park@atmel.com>,
	"Lee, Glen" <glen.lee@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <DUB128-W49FB60890BF7AB1D0892979CD50@phx.gbl>
 <74F3875218FC364C9618AB19CB60E90580048375@penmbx02.corp.atmel.com>
 <DUB128-W339411DA3C1CF69214E4CB9CAD0@phx.gbl>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <56C3CBE3.9090408@atmel.com> (sfid-20160217_022659_539390_A03DDDD9)
Date: Wed, 17 Feb 2016 10:24:51 +0900
MIME-Version: 1.0
In-Reply-To: <DUB128-W339411DA3C1CF69214E4CB9CAD0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

Please check the latest update from the https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/?h=staging-testing.

The tree is not updated yet with the latest.

Thanks,

Tony.



On 2016년 02월 16일 20:33, David Binderman wrote:
> Hello there,
>
> ----------------------------------------
>> You're had old wilc1000 source.
>> Remove the wilc1000_ops structure.
>> (Branch) staging-testing
>> (SHA) ce7b516f3f9e11fe4ee06fad0d7e853bb6e8f160
>> Please receive the latest source.
>>
> I checked the Torvalds source for 4.5-rc4
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/staging/wilc1000/wilc_spi.c?id=refs/tags/v4.5-rc4
>
> and the problem still seems to exist.
>
> Maybe your recent changes aren't getting from staging into the Torvalds tree ?
>
>
> Regards
>
> David Binderman
>
>>   Thanks, BR
>>   Leo
>>
>> -----Original Message-----
>> From: David Binderman [mailto:dcb314@hotmail.com]
>> Sent: Monday, February 08, 2016 9:18 PM
>> To: Kim, Johnny <johnny.kim@atmel.com>; Shin, Austin <Austin.Shin@atmel.com>; Park, Chris <Chris.Park@atmel.com>; Cho, Tony <Tony.Cho@atmel.com>; Lee, Glen <Glen.Lee@atmel.com>; Kim, Leo <Leo.Kim@atmel.com>; linux-wireless@vger.kernel.org
>> Subject: drivers/staging/wilc1000/wilc_spi.c won't compile ?
>>
>> Hello there,
>>
>> drivers/staging/wilc1000/wilc_spi.c:123:34: error: storage size of 'wilc1000_spi_ops' isn't known
>>   static const struct wilc1000_ops wilc1000_spi_ops;
>>                                    ^~~~~~~~~~~~~~~~
>> drivers/staging/wilc1000/wilc_spi.c:123:34: warning: 'wilc1000_spi_ops' defined but not used [-Wunused-const-variable]
>>
>> Suggest remove.
>>
>> Regards
>>
>> David Binderman
>>
>>
>   		 	   		

