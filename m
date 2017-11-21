Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37289 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdKUIGi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 03:06:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
CC: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Daniel Jeang" <dyjeong@qti.qualcomm.com>,
        Yifeng Tu <yifeng@qti.qualcomm.com>
Subject: Re: [PATCHv3 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Tue, 21 Nov 2017 08:06:34 +0000
Message-ID: <87lgj0caye.fsf@kamboji.qca.qualcomm.com> (sfid-20171121_090711_810044_495D0941)
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
        <2831996.nqnu04nqHR@bentobox>   <87tvxocbcn.fsf@kamboji.qca.qualcomm.com>
        <9ab6ffcf-0131-1fb1-13ef-076ec54bd582@dd-wrt.com>
In-Reply-To: <9ab6ffcf-0131-1fb1-13ef-076ec54bd582@dd-wrt.com> (Sebastian
        Gottschall's message of "Tue, 21 Nov 2017 09:00:54 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 21.11.2017 um 08:58 schrieb Kalle Valo:
>> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>>
>>> On Dienstag, 15. November 2016 22:07:29 CET akolli@qti.qualcomm.com wro=
te:
>>>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>>>>
>>>> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
>>>> event, Firmware sends one HTT event for every four PPDUs.
>>>> HTT payload has success pkts/bytes, failed pkts/bytes, retry
>>>> pkts/bytes and rate info per ppdu.
>>>> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
>>>> which are nowadays enabled by default.
>>>>
>>>> Parse peer stats and update the tx rate information per STA.
>>>>
>>>> tx rate, Peer stats are tested on QCA4019 with Firmware version
>>>> 10.4-3.2.1-00028.
>>>>
>>>> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
>>> Why is the support for 10.2.4 firmware not upstreamed? I mean the one w=
hich is
>>> using pktlog to transfer the PEER_STATS information.
>> I'm not sure what you are asking. If you are asking the firmware release
>> mentioned in the commit log that's in ath10k-firmware:
>>
>> https://github.com/kvalo/ath10k-firmware/tree/master/QCA4019/hw1.0/3.2.1
>>
>> But I'm sure you know that already.
>
> i believe he is just talking about a patch which allows to get station
> statistics like rx and tx rate on the firmare 10.2 series which is
> qca988x mainly
>
> this patch was posted here months ago but never got upstream

Any pointers to the patch? Patch title or link to patchwork would help.
I see hundreds of patches per release, I cannot remember all of them.

--=20
Kalle Valo=
