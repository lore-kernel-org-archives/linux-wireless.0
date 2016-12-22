Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33239 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754590AbcLVXBg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 18:01:36 -0500
Date: Thu, 22 Dec 2016 17:01:33 -0600
From: Rob Herring <robh@kernel.org>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com
Subject: Re: [PATCH v3 1/3] NFC: trf7970a: add device tree option for 27MHz
 clock
Message-ID: <20161222230133.jmqgtpyqg4bic7tq@rob-hp-laptop> (sfid-20161223_000201_924016_D11E20FC)
References: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2016 at 11:18:32PM -0500, Geoff Lansberry wrote:
> The TRF7970A has configuration options to support hardware designs
> which use a 27.12MHz clock. This commit adds a device tree option
> 'clock-frequency' to support configuring the this chip for default
> 13.56MHz clock or the optional 27.12MHz clock.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  2 +

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/nfc/trf7970a.c                             | 50 +++++++++++++++++-----
>  2 files changed, 41 insertions(+), 11 deletions(-)
