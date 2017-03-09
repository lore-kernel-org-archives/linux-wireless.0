Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:36166 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754715AbdCIPBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 10:01:39 -0500
Received: by mail-ua0-f182.google.com with SMTP id 72so81792155uaf.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 07:01:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488543607.25750.1.camel@sipsolutions.net>
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com> <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com> <1487680651.2215.5.camel@sipsolutions.net>
 <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com> <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
 <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com> <1248c04b-a643-9254-383c-707ab68c0815@broadcom.com>
 <CA+gyVQ24qDqpOBKPjVaZ_BFAJa9kLMjA=nD8FF8V7HvxUkWb=w@mail.gmail.com> <1488543607.25750.1.camel@sipsolutions.net>
From: Jithu Jance <jithu.jance@broadcom.com>
Date: Thu, 9 Mar 2017 20:23:31 +0530
Message-ID: <CA+gyVQ2sEafO2iivLNUhQUx+n7QD7EVm01Pu8zqj26uwS2t4Lw@mail.gmail.com> (sfid-20170309_160142_495336_F6C6E304)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>,
        Avraham Stern <avraham.stern@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 3, 2017 at 5:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Perhaps instead it'd make sense to instead include the new AUTHORIZED
> flag in the CONNECT_RESULT as well, if authorized? I basically see 3
> valid cases:
>
>  * connection successful with authorized port
>  * connection successful with need for 1X handshake (non-offloaded)
>  * connection failed
>
> Why should we have the case of
>  * association successful but 4-way-HS failed
>
> separately?

Sorry for delayed reply. Makes sense. Authorized flag should do the
job. Thanks Johannes!


-- 

- Jithu Jance
