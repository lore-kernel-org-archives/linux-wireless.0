Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51445 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbeCOH5l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:57:41 -0400
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
 <CACna6ryiAqeW7Awr=o5yydBaTY=+TQmW0DvB6wFO+fQOwFJSgQ@mail.gmail.com>
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <9de41438-ab95-9fe5-e414-1790de888a84@i2se.com> (sfid-20180315_085745_102795_7782B434)
Date: Thu, 15 Mar 2018 08:57:18 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6ryiAqeW7Awr=o5yydBaTY=+TQmW0DvB6wFO+fQOwFJSgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.03.2018 um 07:27 schrieb Rafał Miłecki:
> On 14 March 2018 at 20:02, Stefan Wahren <stefan.wahren@i2se.com> wrote:
>> The commit "regulatory: add NUL to request alpha2" increases the length of
>> alpha2 to 3. This causes a regression on brcmfmac, because
>> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
>> array. So fix this accordingly.
>>
>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> It sounds like it's worth a:
> Fixes: <sha> ("regulatory: add NUL to request alpha2")

I wasn't sure that i can take the hash from linux-next. I will add this.

Thanks
Stefan
