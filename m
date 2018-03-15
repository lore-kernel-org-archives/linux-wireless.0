Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35976 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbeCOJ15 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:27:57 -0400
Received: by mail-wm0-f49.google.com with SMTP id i194so9031519wmg.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 02:27:56 -0700 (PDT)
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
To: Kalle Valo <kvalo@codeaurora.org>,
        Stefan Wahren <stefan.wahren@i2se.com>
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
 <87o9jp7l95.fsf@kamboji.qca.qualcomm.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AAA3C9A.3040907@broadcom.com> (sfid-20180315_102800_354804_0A724DCD)
Date: Thu, 15 Mar 2018 10:27:54 +0100
MIME-Version: 1.0
In-Reply-To: <87o9jp7l95.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/15/2018 10:15 AM, Kalle Valo wrote:
> Stefan Wahren <stefan.wahren@i2se.com> writes:
>
>> The commit "regulatory: add NUL to request alpha2" increases the length of
>> alpha2 to 3. This causes a regression on brcmfmac, because
>> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
>> array. So fix this accordingly.
>>
>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>
> Arend, the first release for 657308f73e67 is v4.16-rc3 so should this go
> to v4.16 as well?
>
> And "wireless:" in the title is useless, I can remove that.

And ": cfg80211" as well?

Regards,
Arend
