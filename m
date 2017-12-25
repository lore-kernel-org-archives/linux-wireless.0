Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:42651 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbdLYQLM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Dec 2017 11:11:12 -0500
Received: by mail-wr0-f180.google.com with SMTP id w107so7312349wrb.9
        for <linux-wireless@vger.kernel.org>; Mon, 25 Dec 2017 08:11:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5281f48b04f8f593ec06e72a041ec021@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-4-git-send-email-alagusankar@silex-india.com>
 <87lghu9247.fsf@kamboji.qca.qualcomm.com> <5281f48b04f8f593ec06e72a041ec021@silex-india.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 25 Dec 2017 08:11:09 -0800
Message-ID: <CAJ-Vmon-KSR4JOMspwFC6YO2DHJW6mRL1b=6F++X8zJX=di2qg@mail.gmail.com> (sfid-20171225_171120_271941_65CB224A)
Subject: Re: [PATCH 03/11] ath10k_sdio: DMA bounce buffers for read write
To: Alagu Sankar <alagusankar@silex-india.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, silexcommon@gmail.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think Kalle is pointing out that maybe it's the SDHCI driver
responsibility to do the bounce buffering?



-adrian
