Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753456AbcLSLpF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 06:45:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Thiagarajan\, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "nbd\@nbd.name" <nbd@nbd.name>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
        <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
        <1481794142.31776.5.camel@sipsolutions.net>
        <58528607.7090101@qti.qualcomm.com>
        <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
        <1481809984.2582.5.camel@sipsolutions.net>
        <58537DA3.1090901@qti.qualcomm.com>
Date: Mon, 19 Dec 2016 13:45:00 +0200
In-Reply-To: <58537DA3.1090901@qti.qualcomm.com> (Vasanthakumar Thiagarajan's
        message of "Fri, 16 Dec 2016 05:37:39 +0000")
Message-ID: <878trckurn.fsf@purkki.adurom.net> (sfid-20161219_124606_543289_BCC685FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com> writes:

> On Thursday 15 December 2016 07:23 PM, Johannes Berg wrote:
>>
>>>> I agree. Dynamic switch part is buggy, we can start with not
>>>> allowing interfaces resulting in dynamic switch.
>>>
>>> Does this mean that when bringing up multiple interfaces, users would
>>> need to figure out the 'magic' order that works?
>>
>> I think we need to talk about hardware capabilities at this point.
>
> QCA988X does not have capability to configure vif specific decap mode. Encap mode
> is configurable per packet for all the ath10k based chips so this part should be
> fine to support per vif configuration. Newer QCA chips like QCA9984, QCA4019, QCA9888
> and QCA99X0 supports decap mode configuration per vif.

When you say "all" are you also taking into account QCA6174 and QCA9377?

Just checking...

-- 
Kalle Valo
