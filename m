Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34080 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcCXW2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 18:28:43 -0400
Received: by mail-yw0-f193.google.com with SMTP id f6so7263590ywa.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2016 15:28:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e7c973ebdbc2fc49bc7bd9734547ab23bb7ee181.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
	<e7c973ebdbc2fc49bc7bd9734547ab23bb7ee181.1458262312.git.julian.calaby@gmail.com>
Date: Fri, 25 Mar 2016 02:28:42 +0400
Message-ID: <CA++WF2N--8y87mCQc+OxiqkfBtGiCxBCbtmTWQMRCr02iAVmPQ@mail.gmail.com> (sfid-20160324_232858_425981_1A54E20A)
Subject: Re: [PATCH 02/19] ipw2x00: use to_pci_dev()
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Geliang Tang <geliangtang@163.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2016 at 06:20, Julian Calaby <julian.calaby@gmail.com> wrote:
> From: Geliang Tang <geliangtang@163.com>
>
> Use to_pci_dev() instead of open-coding it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Stanislav.
