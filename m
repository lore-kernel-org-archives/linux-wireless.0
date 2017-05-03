Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753168AbdECOri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 10:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 3 May 2017 09:47:13 -0500
Message-ID: <CAL_JsqKktwFmxXijB0FVVoWGkswXm3twzD7She7zGR=rVQ4hWA@mail.gmail.com> (sfid-20170503_164810_535775_D18795F1)
Subject: Re: [PATCHv2 0/4] Motorola Droid 4: Add WL1285C support
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 3, 2017 at 9:22 AM, Sebastian Reichel
<sebastian.reichel@collabora.co.uk> wrote:
> Hi,
>
> Motorola Droid 4 uses a WL1285C, as visible on iFixit [0]. This
> fixes the DT file to use correct compatible for the wifi node
> and adds the bluetooth node.
>
> [0] https://www.ifixit.com/Teardown/Motorola+Droid+4+Teardown/7759#s31961
>
> Changes to PATCHv1:
>  - use proper compatible value for bluetooth / shared transport
>  - add patches fixing wlcore compatible for Droid 4
>
> -- Sebastian
>
> Sebastian Reichel (4):
>   wlcore: add wl1285 compatible
>   ARM: dts: omap4-droid4: Use wl1285 for wifi compatible
>   Bluetooth: hci_ll: Add compatible values for more WL chips
>   ARM: dts: omap4-droid4: Add bluetooth

For the series,

Reviewed-by: Rob Herring <robh@kernel.org>
