Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753155AbeCBFOb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 00:14:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Tamizh chelvam <tamizhr@codeaurora.org>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
        <5A9856CE.8000005@broadcom.com>
Date: Fri, 02 Mar 2018 07:14:27 +0200
In-Reply-To: <5A9856CE.8000005@broadcom.com> (Arend van Spriel's message of
        "Thu, 1 Mar 2018 20:38:54 +0100")
Message-ID: <87po4ndpos.fsf@purkki.adurom.net> (sfid-20180302_061436_117442_F00B6098)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/1/2018 6:59 PM, Tamizh chelvam wrote:
>> From: Tamizh chelvam <tamizhr@codeaurora.org>
>>
>> This patch introduces NL80211_CMD_SET_BTCOEX command and
>> NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.
>
> What kind of btcoex are we talking about here? Is it signalling
> between wlan and bt to get access to the shared RF.

Yes, at least that's how I understand this.

> Why would it require user-space interaction? Are there no options for
> wlan to detect bt is in use, ie. bt hci is setup, and vice versa. Can
> it be indicated in platform data or device tree. Trying to understand
> the use-case here.

One use case is being able to disable btcoex in case of problems or to
test if it's btcoex related. I think during the last five years the need
for this interface has come every once in a while.

-- 
Kalle Valo
