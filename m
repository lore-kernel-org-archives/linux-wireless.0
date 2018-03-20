Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:42939 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbeCTVHo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 17:07:44 -0400
Received: by mail-ot0-f178.google.com with SMTP id v23-v6so3366509oth.9
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 14:07:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCB_eLN8Gn0fRmKSFWSa_Yrw3+BB05Hwp_yNyYwhsS+s5w@mail.gmail.com>
References: <20180226090917.7iabysywbv6h4rqr@alienware17> <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl> <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com>
 <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl> <874lli7mk5.fsf@codeaurora.org>
 <5AA99559.2070605@broadcom.com> <CAFBinCB_eLN8Gn0fRmKSFWSa_Yrw3+BB05Hwp_yNyYwhsS+s5w@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 20 Mar 2018 22:07:42 +0100
Message-ID: <CACna6rzJs0d_q42OSv8E_qgGa_TKmTsq5tC823Su41MPtbWOZg@mail.gmail.com> (sfid-20180320_220747_778492_70852848)
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bas Vermeulen <bvermeul@blackstar.nl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>, dev@kresin.me
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2018 at 09:11, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> - some ship with a broken EEPROM that enables the 5GHz band on a
> 2.4GHz-only card, which is why we need "qca,disable-5ghz"

No. You just need to use ieee80211-freq-limit.

--=20
Rafa=C5=82
