Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33890 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941736AbcLVXC3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 18:02:29 -0500
Date: Thu, 22 Dec 2016 17:02:27 -0600
From: Rob Herring <robh@kernel.org>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com
Subject: Re: [PATCH v3 2/3] NFC: trf7970a: Add device tree option of 1.8 Volt
 IO voltage
Message-ID: <20161222230227.fubwn6wjmwcf5vsr@rob-hp-laptop> (sfid-20161223_000254_017324_0DE1F291)
References: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
 <1482380314-16440-2-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482380314-16440-2-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2016 at 11:18:33PM -0500, Geoff Lansberry wrote:
> The TRF7970A has configuration options for supporting hardware designs
> with 1.8 Volt or 3.3 Volt IO.   This commit adds a device tree option,
> using a fixed regulator binding, for setting the io voltage to match
> the hardware configuration. If no option is supplied it defaults to
> 3.3 volt configuration.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  2 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/nfc/trf7970a.c                             | 26 +++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
