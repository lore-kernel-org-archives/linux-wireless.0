Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56361 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935875AbcIZSQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 14:16:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        "Avinash Patil" <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        "Sergei Maksimenko" <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
        <99f0c921-1230-0896-2bc5-4a12eb81dca1@quantenna.com>
        <87oa3byln4.fsf@kamboji.qca.qualcomm.com>
        <7ecc6f46-a65f-2342-d495-0decdeeef8fd@quantenna.com>
Date: Mon, 26 Sep 2016 21:16:40 +0300
In-Reply-To: <7ecc6f46-a65f-2342-d495-0decdeeef8fd@quantenna.com>
        (IgorMitsyanko's message of "Mon, 26 Sep 2016 15:45:40 +0300")
Message-ID: <87wphyy19z.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_201651_284047_093C190B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> On 09/26/2016 01:56 PM, Kalle Valo wrote:
>> IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:
>>> On 09/17/2016 04:46 PM, Kalle Valo wrote:
>>
>> For the initial submission please freeze the driver, otherwise it's pain
>> to review as the driver changes too much in-between review rounds. So at
>> this stage only minimal changes, please.
>>
>> You can continue adding new features and making changes, but do those as
>> follow up patches and use the initial submission as the baseline for the
>> new patches. Once the driver is applied you can submit the rest of the
>> patches adding new features and they will be reviewed similarly like all
>> other wireless patches.
>
> Ok, we will keep patch modification to minimum between revisions, but
> channels-related changes are something we would like to apply: we're
> setting SELF_MANAGED bit right now and do not handle regulatory hints
> from cfg80211, having all the regulatory-related info fixed on device
> itself (region, per-channel Tx powers, DFS requirements). This info is
> what was used to pass regulatory authorities certification, and
> considering seriousness of regulatory compliance requirement it's
> probably better to use the info that is known to be accepted.
> Would it be acceptable if we keep rates/capabilities logic intact, but
> will modify channel-related logic in next patch revision?

Sure, regulatory compliance is important and it's understandable that
you want to fix that. Just give a short summary in the change log what
you changed regarding regulatory to make it easier for the reviewers.

-- 
Kalle Valo
