Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:35531 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751100AbdKUIA6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 03:00:58 -0500
Subject: Re: [PATCHv3 1/2] ath10k: add per peer htt tx stats support for 10.4
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Daniel Jeang <dyjeong@qti.qualcomm.com>,
        Yifeng Tu <yifeng@qti.qualcomm.com>
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
 <2831996.nqnu04nqHR@bentobox> <87tvxocbcn.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <9ab6ffcf-0131-1fb1-13ef-076ec54bd582@dd-wrt.com> (sfid-20171121_090127_333772_8A2E5758)
Date: Tue, 21 Nov 2017 09:00:54 +0100
MIME-Version: 1.0
In-Reply-To: <87tvxocbcn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 21.11.2017 um 08:58 schrieb Kalle Valo:
> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>
>> On Dienstag, 15. November 2016 22:07:29 CET akolli@qti.qualcomm.com wrote:
>>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>>>
>>> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
>>> event, Firmware sends one HTT event for every four PPDUs.
>>> HTT payload has success pkts/bytes, failed pkts/bytes, retry
>>> pkts/bytes and rate info per ppdu.
>>> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
>>> which are nowadays enabled by default.
>>>
>>> Parse peer stats and update the tx rate information per STA.
>>>
>>> tx rate, Peer stats are tested on QCA4019 with Firmware version
>>> 10.4-3.2.1-00028.
>>>
>>> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
>> Why is the support for 10.2.4 firmware not upstreamed? I mean the one which is
>> using pktlog to transfer the PEER_STATS information.
> I'm not sure what you are asking. If you are asking the firmware release
> mentioned in the commit log that's in ath10k-firmware:
>
> https://github.com/kvalo/ath10k-firmware/tree/master/QCA4019/hw1.0/3.2.1
>
> But I'm sure you know that already.

i believe he is just talking about a patch which allows to get station 
statistics like rx and tx rate on the firmare 10.2 series which is 
qca988x mainly

this patch was posted here months ago but never got upstream

>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
