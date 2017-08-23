Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:53690 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752635AbdHWADm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 20:03:42 -0400
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
 <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
 <2e174b5d-b8c2-3303-b66c-cac656478adb@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <cd9a78e4-1865-1de4-956e-bc8cd6470daa@mnementh.co.uk> (sfid-20170823_020345_898822_C3E60DEC)
Date: Wed, 23 Aug 2017 01:03:40 +0100
MIME-Version: 1.0
In-Reply-To: <2e174b5d-b8c2-3303-b66c-cac656478adb@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/08/17 20:44, Arend van Spriel wrote:
> By the way, the driver prefix in the subject is wrong, ie. brcmfamc
> should be brcmfmac. I think it already was wrong in the previous series,
> but I forgot to mention it.

Drat. well spotted :)

-Ian
