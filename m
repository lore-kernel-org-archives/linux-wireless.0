Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45471 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1HPAdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 20:33:04 -0400
Message-ID: <4E49BAB1.7060303@qca.qualcomm.com> (sfid-20110816_023311_437025_270E193E)
Date: Mon, 15 Aug 2011 17:32:49 -0700
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Lin Tony-B19295 <B19295@freescale.com>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<rmani@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de> <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net> <4E496CA7.7000604@hauke-m.de>
In-Reply-To: <4E496CA7.7000604@hauke-m.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2011 11:59 AM, Hauke Mehrtens wrote:
> On 08/15/2011 07:06 AM, Lin Tony-B19295 wrote:
>> Where can I get corresponding firmware?
>>
>> tony
> 
> Hi tony,
> 
> there is a firmware for these devices in the linux-firmware git [0], but
> I do not know if it still works with this driver.
> 
> Probably some of the ath6kl developer could help you more than me.

Yes, the firmware in linux-firmware should work. If not, please report
it to linux-wireless mailing list.

Kalle
