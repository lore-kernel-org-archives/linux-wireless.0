Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:35011 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755821AbeARKnY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 05:43:24 -0500
Received: by mail-ua0-f181.google.com with SMTP id g16so15259097ual.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 02:43:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
From: Carlo Caione <carlo@endlessm.com>
Date: Thu, 18 Jan 2018 10:43:23 +0000
Message-ID: <CAL9uMOFDtBORCY3FO_nnUg1fpdio2FfHgfoUN4z3svSoQoT5VA@mail.gmail.com> (sfid-20180118_114330_928976_AAB35AC7)
Subject: Re: RTL8723bu: poor signal and connection troubles
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        mylene.josserand@free-electrons.com,
        Linux Upstreaming Team <linux@endlessm.com>,
        briselec@gmail.com, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:15 PM, Carlo Caione <carlo@endlessm.com> wrote:
> Hi,
> this is a follow up email to [0] since the problem was never fully
> investigated / solved and I keep seeing the same problem also on my
> hardware.
>
> Also in my case the hardware is a rtl8723bt transceiver
> (0x0bda:0xb720), this time shipped on the internal USB bus in a cheap
> laptop branded Zyrex Sky 232.
>
> As already reported by Mylene the problem is that using this
> transceiver and the latest Linus master you can barely see any WiFi
> network around and also when a WiFi network is actually seen, the
> connection is impossible since the signal strength is too low to have
> a reliable connection. Of course during my tests BT is off and no BT
> driver is probed at all.
>
> Using the downstream driver at [1] everything works correctly.
>
> I tried to debug a bit the issue, in particular comparing functions
> and registers related to the antenna setup (.power_on, .enable_rf,
> .phy_init_antenna_selection, .phy_iq_calibrate hooks) but everything
> seems pretty much the same on the two drivers (even though slightly
> differences do exist).
>
> Any idea / suggestion on how to debug this problem? I guess it's worth
> to start looking at this since several platforms are being affected
> now.

Jes,
anything to comment about this issue? (ping)

-- 
Carlo Caione  |  +44.7384.69.16.04  |  Endless
