Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33137 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034141AbdD1UXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 16:23:40 -0400
Date: Fri, 28 Apr 2017 15:23:38 -0500
From: Rob Herring <robh@kernel.org>
To: Mark Greer <mgreer@animalcreek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 6/9] NFC: trf7970a: Remove support for
 'vin-voltage-override' DT property
Message-ID: <20170428202338.iosgu2o4yxg3foig@rob-hp-laptop> (sfid-20170428_222345_155262_DAA08AF9)
References: <20170425224356.11498-1-mgreer@animalcreek.com>
 <20170425224356.11498-7-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425224356.11498-7-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 25, 2017 at 03:43:53PM -0700, Mark Greer wrote:
> The 'vin-voltage-override' DT property is used by the trf7970a
> driver to override the voltage presented to the driver by the
> regulator subsystem.  This is unnecessary as properly specifying
> the regulator chain via DT properties will accomplish the same
> thing.  Therefore, remove support for 'vin-voltage-override'.
> 
> Signed-off-by: Mark Greer <mgreer@animalcreek.com>
> ---
>  Documentation/devicetree/bindings/net/nfc/trf7970a.txt |  2 --
>  drivers/nfc/trf7970a.c                                 | 11 +----------
>  2 files changed, 1 insertion(+), 12 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
