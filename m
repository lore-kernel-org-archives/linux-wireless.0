Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37742 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdGQTO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:14:56 -0400
Received: by mail-wm0-f48.google.com with SMTP id b134so3752648wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 12:14:55 -0700 (PDT)
Subject: Re: BUG: brcmfmac: rework headroom check in .start_xmit() causes
 43430a1 to fail.
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        davem@davemloft.net
References: <86761c42-c91d-d4a7-3ba4-314612dd7fd1@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9ad41664-804f-eaf4-de59-ad3308178362@broadcom.com> (sfid-20170717_211459_884780_599ACF1B)
Date: Mon, 17 Jul 2017 21:14:53 +0200
MIME-Version: 1.0
In-Reply-To: <86761c42-c91d-d4a7-3ba4-314612dd7fd1@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-07-17 21:03, Ian Molton wrote:
> Hi folks,
> 
> I've found that:
> 
> 270a6c1f65fe brcmfmac: rework headroom check in .start_xmit()
> 
> Causes the 43430a1 to become non-responsive. The log starts emitting
> these messages:

A fix is already pending in patchwork:

https://patchwork.kernel.org/patch/9836383/

Thanks,
Arend
