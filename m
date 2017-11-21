Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:38104 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751175AbdKUJAY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 04:00:24 -0500
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
 <87tvxocbcn.fsf@kamboji.qca.qualcomm.com>
 <9ab6ffcf-0131-1fb1-13ef-076ec54bd582@dd-wrt.com>
 <4295821.C9ZrSID8fs@bentobox> <87h8toc9dq.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <566f915b-0dbc-573f-3a6a-95ecf571674a@dd-wrt.com> (sfid-20171121_100137_000043_EEB6C6F7)
Date: Tue, 21 Nov 2017 10:00:20 +0100
MIME-Version: 1.0
In-Reply-To: <87h8toc9dq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

maybe this one?

i have this qca988x supporting tx/rx rate patch in my local tree. just 
need to extract it again

  ath10k: report per-station tx/rate rates to mac80211

Am 21.11.2017 um 09:40 schrieb Kalle Valo:
> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>
>> On Dienstag, 21. November 2017 09:00:54 CET Sebastian Gottschall wrote:
>> [...]
>>>>> Why is the support for 10.2.4 firmware not upstreamed? I mean the one which is
>>>>> using pktlog to transfer the PEER_STATS information.
>>>> I'm not sure what you are asking. If you are asking the firmware release
>>>> mentioned in the commit log that's in ath10k-firmware:
>>>>
>>>> https://github.com/kvalo/ath10k-firmware/tree/master/QCA4019/hw1.0/3.2.1
>>>>
>>>> But I'm sure you know that already.
>>> i believe he is just talking about a patch which allows to get station
>>> statistics like rx and tx rate on the firmare 10.2 series which is
>>> qca988x mainly
>>>
>>> this patch was posted here months ago but never got upstream
>> Yes, I was talking about that patch (which I didn't find on the
>> mailing list - so a link would be helpful). QCA is gathering a lot of
>> patches (a00-*) at
>> https://source.codeaurora.org/quic/qsdk/oss/system/feeds/wlan-open/tree/mac80211/patches?h=coconut
>> which are often not upstreamed.
> Oh, that. I have always told the team working on that repository that
> they should upstream everything but obviously they don't :/
>
>> The patch
>> a00-0075-ath10k-Add-support-to-parse-per-station-tx-stats-for.patch is
>> the one which is receiving the TX statistics stuff from 10.2.
> I tried to find that patch from the ath10k list archives but didn't find
> it. I only did a quick search so of course it might be submitted still,
> so if anyone finds a link please let me know.
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
