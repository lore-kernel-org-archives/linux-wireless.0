Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53679 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbbCZLVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 07:21:04 -0400
Date: Thu, 26 Mar 2015 12:20:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 8/8] NFC: Add Intel FieldsPeak NFC solution driver
Message-ID: <20150326112053.GB19973@ribalta.ger.corp.intel.com> (sfid-20150326_122109_584542_AC6AFCB1)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-9-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424772112-27399-9-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robert,

Another comment:

On Tue, Feb 24, 2015 at 12:01:52PM +0200, Robert Dolca wrote:
> +static struct i2c_device_id fdp_nci_i2c_id_table[] = {
> +	{"INT339A", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, fdp_nci_i2c_id_table);
> +
> +
> +static const struct acpi_device_id fdp_nci_i2c_acpi_match[] = {
> +	{"INT339A", 0},
> +	{}
> +};
Why don't we have a MODULE_DEVICE_TABLE(acpi, fdp_nci_i2c_acpi_match);
here ?

Cheers,
Samuel.
