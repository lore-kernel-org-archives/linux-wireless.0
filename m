Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:44817 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbeC1SDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 14:03:16 -0400
Received: by mail-ot0-f171.google.com with SMTP id x6-v6so3606565otg.11
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2018 11:03:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLGbRJU=YV4CC_T9dE8F64=D98d8xiy7HsRcO1T9UdhqWAigw@mail.gmail.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com> <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
 <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com>
 <5A8FE4D9.80608@broadcom.com> <CAD8Lp44Q0=jS0gqnt1mMfjRe6sTx3Z7n9=iGvk3VFGK2549V7g@mail.gmail.com>
 <5AA114A9.8050801@broadcom.com> <CALLGbRJU=YV4CC_T9dE8F64=D98d8xiy7HsRcO1T9UdhqWAigw@mail.gmail.com>
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 28 Mar 2018 12:03:14 -0600
Message-ID: <CAD8Lp44a1egt=Zi3j5q0iCBoPExw6m+Xi+OZoY8xnJjLMF6-Dw@mail.gmail.com> (sfid-20180328_200320_014618_8A6E67E3)
Subject: Re: brcmfmac signal/interference issues
To: Steve deRosier <derosier@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, Wright Feng <wright.feng@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2018 at 9:54 AM, Steve deRosier <derosier@gmail.com> wrote:
> Did you check the Bluetooth?  I don't know if this chip has it or if
> it's an independent chip on this board, but if Linux is leaving it
> powered up but not properly configured you could have issues.

I had already disabled it via hciconfig, without any effect on the problem.

Based on your suggestion I also checked BT_REG_ON, which was not being
affected by hciconfig. On AP6255 I believe it is active high, so I
brought it low to disable bluetooth, confirmed with a scope, and the
problem is still there.

Thanks for the suggestion anyway!
Daniel
