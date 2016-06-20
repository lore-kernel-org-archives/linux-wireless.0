Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:11680
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754484AbcFTV7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 17:59:04 -0400
Subject: Re: [PATCH] qtnfmac: announcement of new FullMAC driver for Quantenna
 chipsets
To: Kalle Valo <kvalo@codeaurora.org>
References: <1464288752-6625-1-git-send-email-avinashp@quantenna.com>
 <CAOiHx==C56Pj768bRX16VOaxj0Qf_oh5KXfhFJakT2zi-SokQQ@mail.gmail.com>
 <0f6a9c71-f6d5-235f-2883-114c22ebebff@quantenna.com>
 <87inxjlsnc.fsf@kamboji.qca.qualcomm.com>
CC: Jonas Gorski <jogo@openwrt.org>,
	Avinash Patil <avinashp@quantenna.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<dlebed@quantenna.com>, <smaksimenko@quantenna.com>,
	<smatyukevich@quantenna.com>, <imitsyanko@quantenna.com>,
	<btherthala@quantenna.com>, <hwang@quantenna.com>,
	<krath@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <32fe6931-0952-4fad-cb5c-cc994ceb8e19@quantenna.com> (sfid-20160620_235935_172515_0ABD9B46)
Date: Tue, 21 Jun 2016 00:22:36 +0300
MIME-Version: 1.0
In-Reply-To: <87inxjlsnc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2016 04:25 PM, Kalle Valo wrote:
> Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> writes:
>
>> On 05/29/2016 02:35 PM, Jonas Gorski wrote:
>>> Hi,
>>>
>>> On 26 May 2016 at 20:52, Avinash Patil <avinashp@quantenna.com> wrote:
>>>> This patch adds support for new FullMAC WiFi driver for Quantenna
>>>> QSR10G chipsets.
>>>>
>>>> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
>>>> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
>>>> supports 160M, 8x8 configuration.
>>>> FW supports 8 concurrent virtual interfaces on each WMAC.
>>>>
>>>> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
>>>> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.
>>> Nice to see this one, will you also provide a pearl-linux.lzma.img as
>>> required for the firmware? What about cards in embedded devices, might
>>> they require a uboot as well? Since requesting uboot seems to be
>>> specifically supported by the card/firmware interface.
>> Hi Jonas,
>> we will provide firmware, but we're not sure at which point it should
>> be done: addressing any review comments for driver may affect firmware
>> itself, probably the best time to provide firmware would be after new
>> driver is accepted and merged?
> I would prefer to see the firmware images publically available before
> the driver gets applied. What if you send the firmware patches as RFC
> only to linux-wireless? That way linux-firmware.git maintainers won't
> apply them, hopefully. And mention in the commit log that this is just
> for testing purposes, not to be applied.
>

Kalle, sure, we will send firmware binary as an RFC to linux-wireless 
while patch itself is in review.


