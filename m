Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:63308 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755001AbdDEJGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 05:06:21 -0400
Date: Wed, 5 Apr 2017 11:06:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgreer@animalcreek.com, justin@kuvee.com
Subject: Re: [PATCH v3 1/3] NFC: trf7970a: add device tree option for 27MHz
 clock
Message-ID: <20170405090611.GF2136@zurbaran.ger.intel.com> (sfid-20170405_172443_906471_7DF7E7A3)
References: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Geoff,

On Wed, Dec 21, 2016 at 11:18:32PM -0500, Geoff Lansberry wrote:
> The TRF7970A has configuration options to support hardware designs
> which use a 27.12MHz clock. This commit adds a device tree option
> 'clock-frequency' to support configuring the this chip for default
> 13.56MHz clock or the optional 27.12MHz clock.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  2 +
>  drivers/nfc/trf7970a.c                             | 50 +++++++++++++++++-----
>  2 files changed, 41 insertions(+), 11 deletions(-)
Patches #1 and #2 applied to nfc-next. I'll wait for you to rework #3
before merging.

Cheers,
Samuel.
