Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33329 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbcK2HhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 02:37:09 -0500
Received: by mail-oi0-f67.google.com with SMTP id f201so17211695oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 23:37:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 29 Nov 2016 08:37:08 +0100
Message-ID: <CACna6rxszuTY3g=brCkWmwX7mT0-ptjpQMG+YTrPzfoc=dJvcA@mail.gmail.com> (sfid-20161129_083713_104590_E769BFAF)
Subject: Re: [PATCH 00/12] brcmfmac: scheduled scan cleanup and chip support
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 November 2016 at 11:25, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> This patch series contains:
> * cleanup of scheduled scan code.
> * fix handling schedules scan results for newer chips.
> * support for bcm43341 chipset with different chip id.
> * support rev6 of PCIe device interface.
>
> The series is intended for 4.10 and applies to the master branch
> of the wireless-drivers-next repository.

Tested with BCM43602 on SR400ac router, it still initializes fine, I
can create multiple AP interfaces and use them.
