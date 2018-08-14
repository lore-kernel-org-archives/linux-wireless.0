Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbeHNRby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 13:31:54 -0400
Received: from mail-qt0-f182.google.com (mail-qt0-f182.google.com [209.85.216.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9D121741
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 14:44:26 +0000 (UTC)
Received: by mail-qt0-f182.google.com with SMTP id b15-v6so21300769qtp.11
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 07:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <1533306095-19946-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1533306095-19946-1-git-send-email-sgruszka@redhat.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Tue, 14 Aug 2018 10:44:14 -0400
Message-ID: <CA+5PVA43=DQBdGE4CvpTki5caSyfQ02TgV=6CRHukGzAuhsytQ@mail.gmail.com> (sfid-20180814_164429_612763_A6EF0AE4)
Subject: Re: [PATCH] linux-firmware: add firmware for mt76x0
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        linux-mediatek@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 3, 2018 at 10:21 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> Add binary firmware for MT7610u based devices.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  WHENCE               |   9 +++++++++
>  mediatek/mt7610u.bin | Bin 0 -> 80288 bytes
>  2 files changed, 9 insertions(+)
>  create mode 100644 mediatek/mt7610u.bin

Applied and pushed out.  Thanks.

josh
