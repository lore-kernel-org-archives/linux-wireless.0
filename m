Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeCOJa3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:30:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
        <87o9jp7l95.fsf@kamboji.qca.qualcomm.com>
        <5AAA3C9A.3040907@broadcom.com>
Date: Thu, 15 Mar 2018 11:30:22 +0200
In-Reply-To: <5AAA3C9A.3040907@broadcom.com> (Arend van Spriel's message of
        "Thu, 15 Mar 2018 10:27:54 +0100")
Message-ID: <87fu517kk1.fsf@kamboji.qca.qualcomm.com> (sfid-20180315_103033_044581_7D1A1442)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/15/2018 10:15 AM, Kalle Valo wrote:
>> Stefan Wahren <stefan.wahren@i2se.com> writes:
>>
>>> The commit "regulatory: add NUL to request alpha2" increases the length of
>>> alpha2 to 3. This causes a regression on brcmfmac, because
>>> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
>>> array. So fix this accordingly.
>>>
>>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>>
>> Arend, the first release for 657308f73e67 is v4.16-rc3 so should this go
>> to v4.16 as well?
>>
>> And "wireless:" in the title is useless, I can remove that.
>
> And ": cfg80211" as well?

Ok, I'll remove that.

-- 
Kalle Valo
