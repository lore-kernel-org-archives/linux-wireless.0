Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14987 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbcJLFAd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 01:00:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Wed, 12 Oct 2016 04:59:49 +0000
Message-ID: <87r37mgo1n.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_070044_935847_AB912AD6)
References: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com>
        <1475852332-18217-2-git-send-email-akolli@qti.qualcomm.com>
        <CAEFj985tCc_4Q_zfwRtoT0fjfZv0u_c5E8SRSQVz=V4tiHh+GA@mail.gmail.com>
In-Reply-To: <CAEFj985tCc_4Q_zfwRtoT0fjfZv0u_c5E8SRSQVz=V4tiHh+GA@mail.gmail.com>       (Yeoh
 Chun-Yeow's message of "Sat, 8 Oct 2016 22:16:37 +0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

> On Fri, Oct 7, 2016 at 10:58 PM,  <akolli@qti.qualcomm.com> wrote:
>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>>
>> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
>> event, Firmware sends one HTT event for every four PPDUs.
>> HTT payload has success pkts/bytes, failed pkts/bytes, retry
>> pkts/bytes and rate info per ppdu.
>> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
>> which are nowadays enabled by default.
>>
>> Parse peer stats and update the tx rate information per STA.
>>
>> tx rate, Peer stats are tested on QCA4019 with Firmware version
>> 10.4-3.2.1-00028.
>>
>
> Is QCA988X supported? I have tried to test with
> firmware-5.bin_10.2.4.70.56 but not working.

My understanding is that 10.2 branch does not have this feature,
unfortunately.

--=20
Kalle Valo=
