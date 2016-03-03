Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbcCCJf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 04:35:56 -0500
Date: Thu, 3 Mar 2016 10:35:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] nfc: pn544: Drop two useless checks in ACPI probe path
Message-ID: <20160303093552.GA28928@zurbaran.home> (sfid-20160303_103600_461720_0660F283)
References: <1456997178-7673-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456997178-7673-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mika,

On Thu, Mar 03, 2016 at 11:26:18AM +0200, Mika Westerberg wrote:
> When pn544_hci_i2c_acpi_request_resources() gets called we already know
> that the entries in ->acpi_match_table have matched ACPI ID of the device.
> In addition I2C client pointer cannot be NULL in any case (otherwise I2C
> core would not call ->probe() for the driver in the first place).
> 
> Drop the two useless checks from the driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/nfc/pn544/i2c.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
