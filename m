Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37581 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1HQE2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 00:28:44 -0400
Message-ID: <4E4B437A.1070200@qca.qualcomm.com> (sfid-20110817_062852_110799_81761FFE)
Date: Tue, 16 Aug 2011 21:28:42 -0700
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Lin Tony-B19295 <B19295@freescale.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de> <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net> <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net> <4E4A7159.3090004@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2011 07:19 PM, Lin Tony-B19295 wrote:
>> I have a patch pending to add suspend support and will send it as
>> soon as I find some free time. But the wifi connection will be lost
>> in resume anyway. If you want to maintain the connection to AP
>> during suspend then you are looking for wowlan support which ath6kl
>> doesn't currently support.
> 
> Do you have any plan supporting it?

It would be nice to have support for wowlan but I don't know when it
will be implemented. Hopefully sooner than later.

> Besides, the performance seems not good. I got only 5Mb/s
> station->station performance. While another driver released from your
> AE could reach at least 10Mb/s, do you have any idea?

That sounds quite low. Can you describe your test setup in detail,
please? That would help to understand the issue.

Kalle
