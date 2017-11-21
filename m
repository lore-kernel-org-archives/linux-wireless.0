Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40623 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdKUIkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 03:40:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Daniel Jeang" <dyjeong@qti.qualcomm.com>,
        Yifeng Tu <yifeng@qti.qualcomm.com>
Subject: Re: [PATCHv3 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Tue, 21 Nov 2017 08:40:34 +0000
Message-ID: <87h8toc9dq.fsf@kamboji.qca.qualcomm.com> (sfid-20171121_094043_412481_A0A5F982)
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
        <87tvxocbcn.fsf@kamboji.qca.qualcomm.com>
        <9ab6ffcf-0131-1fb1-13ef-076ec54bd582@dd-wrt.com>
        <4295821.C9ZrSID8fs@bentobox>
In-Reply-To: <4295821.C9ZrSID8fs@bentobox> (Sven Eckelmann's message of "Tue,
        21 Nov 2017 09:20:32 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> On Dienstag, 21. November 2017 09:00:54 CET Sebastian Gottschall wrote:
> [...]
>> >> Why is the support for 10.2.4 firmware not upstreamed? I mean the one=
 which is
>> >> using pktlog to transfer the PEER_STATS information.
>> > I'm not sure what you are asking. If you are asking the firmware relea=
se
>> > mentioned in the commit log that's in ath10k-firmware:
>> >
>> > https://github.com/kvalo/ath10k-firmware/tree/master/QCA4019/hw1.0/3.2=
.1
>> >
>> > But I'm sure you know that already.
>>=20
>> i believe he is just talking about a patch which allows to get station=20
>> statistics like rx and tx rate on the firmare 10.2 series which is=20
>> qca988x mainly
>>=20
>> this patch was posted here months ago but never got upstream
>
> Yes, I was talking about that patch (which I didn't find on the
> mailing list - so a link would be helpful). QCA is gathering a lot of
> patches (a00-*) at
> https://source.codeaurora.org/quic/qsdk/oss/system/feeds/wlan-open/tree/m=
ac80211/patches?h=3Dcoconut
> which are often not upstreamed.

Oh, that. I have always told the team working on that repository that
they should upstream everything but obviously they don't :/

> The patch
> a00-0075-ath10k-Add-support-to-parse-per-station-tx-stats-for.patch is
> the one which is receiving the TX statistics stuff from 10.2.

I tried to find that patch from the ath10k list archives but didn't find
it. I only did a quick search so of course it might be submitted still,
so if anyone finds a link please let me know.

--=20
Kalle Valo=
