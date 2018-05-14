Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752293AbeENMFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 08:05:19 -0400
Received: from mail-qt0-f180.google.com (mail-qt0-f180.google.com [209.85.216.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E1321748
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 12:05:19 +0000 (UTC)
Received: by mail-qt0-f180.google.com with SMTP id e8-v6so15679587qth.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 05:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <1521209329-59441-1-git-send-email-chi-hsien.lin@cypress.com> <5AF960B6.2010709@broadcom.com>
In-Reply-To: <5AF960B6.2010709@broadcom.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 14 May 2018 08:05:06 -0400
Message-ID: <CA+5PVA7m3wWHyi12rTcpAozj=en9BtnsVAKAbQyvKvPRh_jC4A@mail.gmail.com> (sfid-20180514_140536_935651_3B9D999D)
Subject: Re: [PATCH V3 0/5] Update brcm firmware files
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        chi-hsien.lin@cypress.com,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, wright.feng@cypress.com,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

n Mon, May 14, 2018 at 6:11 AM Arend van Spriel <
arend.vanspriel@broadcom.com> wrote:

> On 3/16/2018 3:08 PM, Chi-Hsien Lin wrote:
> > Update brcm firmware files and WHENCE accordingly.

> Hi firmware-maintainers,

> It seems this series somehow got lost. Can these still be applied. They
> can be found in the linux-wireless patchwork database. I provided links
> below.

All 5 of these move the respective firmware files under the Cypress
license.  It has been pointed out that the Cypress license has some
questionable language in it and that people have been in touch to try and
get this resolved.  I'm personally waiting on applying them until the
licence issue is sorted out.

josh


> Regards,
> Arend
> ---
> > Chi-Hsien Lin (5):
> >    brcm: update firmware for bcm43430

> https://patchwork.kernel.org/patch/10287495/

> >    brcm: update firmware for bcm43340

> https://patchwork.kernel.org/patch/10287497/

> >    brcm: update firmware for bcm43362

> https://patchwork.kernel.org/patch/10287493/

> >    brcm: update firmware for bcm4354

> https://patchwork.kernel.org/patch/10287499/

> >    brcm: update firmware for bcm4356 pcie

> https://patchwork.kernel.org/patch/10287501/
