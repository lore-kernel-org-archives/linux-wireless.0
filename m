Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17044 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQFKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 01:10:31 -0400
Message-ID: <4E4B4D45.2090308@qca.qualcomm.com> (sfid-20110817_071040_615902_763DD5DD)
Date: Tue, 16 Aug 2011 22:10:29 -0700
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Lin Tony-B19295 <B19295@freescale.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de> <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net> <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net> <4E4A7159.3090004@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net> <4E4B437A.1070200@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195BE5@039-SN1MPN1-002.039d.mgd.msft.net> <4E4B48E4 <4E4B4A37.3020300@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195C5A@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <97D3A72708D04647A5AC84A04996E5B5195C5A@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2011 10:01 PM, Lin Tony-B19295 wrote:
>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
>> Sent: Wednesday, August 17, 2011 12:57 PM
>> To: Lin Tony-B19295
>> Cc: Hauke Mehrtens; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
>> wireless@vger.kernel.org; rmani@qca.qualcomm.com
>> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
>>
>> On 08/16/2011 09:53 PM, Lin Tony-B19295 wrote:
>>>>> Set board as client, 'iperf -c pc ipaddr -t 100000 -w 1M -i 3'
>>>>> If using another package, I get 23Mb/s
>>>>
>>>> What wifi settings do you use? (11n, encryption, frequency, etc)
>>>>
>>> 11n, no encryption, 50Mhz.
>>
>> 50 MHz can't be right. Please send me output from 'iw wlan0 link' (or
>> whatever interface you use with ath6kl.
>>
> 
> 50MHz is SDIO interface bus clock, isn't it right?

Hehe, that's true. But I was asking about the wifi channel frequency
which you can check with 'iw wlan0 link' :)

Kalle
