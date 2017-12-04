Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:46901 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdLDRL7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 12:11:59 -0500
Received: by mail-it0-f45.google.com with SMTP id t1so14502331ite.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Dec 2017 09:11:59 -0800 (PST)
From: Li Jin <li.jin@broadcom.com>
References: <1511313990-19334-1-git-send-email-li.jin@broadcom.com> <87o9nejzic.fsf@purkki.adurom.net>
In-Reply-To: <87o9nejzic.fsf@purkki.adurom.net>
MIME-Version: 1.0
Date: Mon, 4 Dec 2017 09:11:57 -0800
Message-ID: <85e925b769ae5d0ed2f9c130a9e2955d@mail.gmail.com> (sfid-20171204_181204_733990_6EF0324F)
Subject: RE: [PATCH INTERNAL V2 1/1] brcmfmac: add console log support with
 configurable read size
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list@cypress.com,
        "BRCM80211-DEV-LIST,PDL" <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless@vger.kernel.org, Jason Uy <jason.uy@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Apologies. The title of this patch should be EXTERNAL. I put down INTERNAL
by mistake.

Thanks!
Li

-----Original Message-----
From: Kalle Valo [mailto:kvalo@codeaurora.org]
Sent: Monday, December 4, 2017 7:15 AM
To: Li Jin
Cc: Wright Feng; Chi-Hsien Lin; Hante Meuleman; Franky Lin; Arend van
Spriel; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
brcm80211-dev-list@cypress.com; brcm80211-dev-list.pdl@broadcom.com;
linux-wireless@vger.kernel.org; Jason Uy
Subject: Re: [PATCH INTERNAL V2 1/1] brcmfmac: add console log support
with configurable read size

Li Jin <li.jin@broadcom.com> writes:

> From: Jason Uy <jason.uy@broadcom.com>
>
> Add support for configurable read size so that older wifi chips that
> have size restrictions can be supported.
>
> Signed-off-by: Jason Uy <jason.uy@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Signed-off-by: Li Jin <li.jin@broadcom.com>

Arend, am I supposed to apply this even if there's this "INTERNAL" tag in
the Subject?

--
Kalle Valo
