Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:22381 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdKUH6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 02:58:10 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Daniel Jeang" <dyjeong@qti.qualcomm.com>,
        Yifeng Tu <yifeng@qti.qualcomm.com>
Subject: Re: [PATCHv3 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Tue, 21 Nov 2017 07:58:01 +0000
Message-ID: <87tvxocbcn.fsf@kamboji.qca.qualcomm.com> (sfid-20171121_085814_278149_D73B22C9)
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
        <2831996.nqnu04nqHR@bentobox>
In-Reply-To: <2831996.nqnu04nqHR@bentobox> (Sven Eckelmann's message of "Fri,
        17 Nov 2017 12:06:06 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> On Dienstag, 15. November 2016 22:07:29 CET akolli@qti.qualcomm.com wrote=
:
>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>>=20
>> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
>> event, Firmware sends one HTT event for every four PPDUs.
>> HTT payload has success pkts/bytes, failed pkts/bytes, retry
>> pkts/bytes and rate info per ppdu.
>> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
>> which are nowadays enabled by default.
>>=20
>> Parse peer stats and update the tx rate information per STA.
>>=20
>> tx rate, Peer stats are tested on QCA4019 with Firmware version
>> 10.4-3.2.1-00028.
>>=20
>> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> Why is the support for 10.2.4 firmware not upstreamed? I mean the one whi=
ch is=20
> using pktlog to transfer the PEER_STATS information.

I'm not sure what you are asking. If you are asking the firmware release
mentioned in the commit log that's in ath10k-firmware:

https://github.com/kvalo/ath10k-firmware/tree/master/QCA4019/hw1.0/3.2.1

But I'm sure you know that already.

--=20
Kalle Valo=
