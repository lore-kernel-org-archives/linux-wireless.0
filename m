Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:34749 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdB0Kmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 05:42:31 -0500
Date: Mon, 27 Feb 2017 11:42:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ilan Elias <ilane@ti.com>,
        Marcel Holtmann <marcel.holtmann@intel.com>
Subject: Re: [PATCH] NFC: remove TI nfcwilink driver
Message-ID: <20170227104219.GF13501@zurbaran.ger.intel.com> (sfid-20170227_114254_387897_A913A6A8)
References: <20170125222307.3044-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170125222307.3044-1-robh@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

On Wed, Jan 25, 2017 at 04:23:07PM -0600, Rob Herring wrote:
> It appears that TI WiLink devices including NFC (WL185x/WL189x) never
> shipped. The only information I found were announcements in Feb
> 2012 about the parts. There's been no activity on this driver besided
> common changes since initially added in Jan 2012. There's also no in
> users that instantiate the platform device (nor DT bindings).
> 
> This is a first step in removing TI ST (shared transport) driver in
> favor of extending the BT hci_ll driver to support WL183x chips.
> 
> Cc: Ilan Elias <ilane@ti.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/nfc/Kconfig     |  11 -
>  drivers/nfc/Makefile    |   1 -
>  drivers/nfc/nfcwilink.c | 578 ------------------------------------------------
>  3 files changed, 590 deletions(-)
>  delete mode 100644 drivers/nfc/nfcwilink.c
Applied to nfc-next, thanks.

Cheers,
Samuel.
