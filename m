Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:51731 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbbCKLWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 07:22:47 -0400
Message-ID: <1426072963.4244.100.camel@x220> (sfid-20150311_122310_419894_F7C10208)
Subject: Re: [PATCH v2 3/3] NFC: nxp-nci_i2c: Add I2C support to NXP NCI
 driver
From: Paul Bolle <pebolle@tiscali.nl>
To: clement.perrochaud@effinnov.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Dave Jones <davej@codemonkey.org.uk>, linux-nfc@lists.01.org,
	=?ISO-8859-1?Q?Cl=E9ment?= Perrochaud
	<clement.perrochaud@nxp.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, davem@davemloft.net, grant.likely@linaro.org,
	lefrique@marvell.com, christophe.ricard@gmail.com,
	cuissard@marvell.com, bzhao@marvell.com, hirent@marvell.com,
	akarwar@marvell.com, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, anda-maria.nicolae@intel.com
Date: Wed, 11 Mar 2015 12:22:43 +0100
In-Reply-To: <1425895925-20593-4-git-send-email-clement.perrochaud@effinnov.com>
References: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com>
	 <1425895925-20593-4-git-send-email-clement.perrochaud@effinnov.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 11:12 +0100, clement.perrochaud@effinnov.com
wrote:
> --- /dev/null
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -0,0 +1,415 @@
> +/*
> + * I2C link layer for the NXP NCI driver
> + *
> + * Copyright (C) 2014  NXP Semiconductors  All rights reserved.
> + *
> + * Authors: Clément Perrochaud <clement.perrochaud@nxp.com>
> + *
> + * Derived from PN544 device driver:
> + * Copyright (C) 2012  Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */

This states the license is GPL v2.

> +MODULE_LICENSE("GPL");

So you probably want
    MODULE_LICENSE("GPL v2");

here.


Paul Bolle

