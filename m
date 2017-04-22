Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33264 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426639AbdDVTfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 15:35:06 -0400
Received: by mail-lf0-f68.google.com with SMTP id 88so12544920lfr.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Apr 2017 12:35:05 -0700 (PDT)
Subject: Re: [PATCH v7 00/10] ath10k: sdio support
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
References: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
Cc: linux-wireless@vger.kernel.org
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <15e7a765-d5f0-677a-51a9-e2a74ef6ed33@gmail.com> (sfid-20170422_213510_951480_70BE5CB4)
Date: Sat, 22 Apr 2017 21:35:02 +0200
MIME-Version: 1.0
In-Reply-To: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-04-13 10:28, Kalle Valo wrote:
> More changes to Erik's SDIO patches. The biggest change in this round
> is refactoring of the ugly ath10k_sdio_io() function.
>
> Only compile tested, I don't have any SDIO boards at the moment.
>
I have tested the patches and they are working as expected...

--
Erik
