Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbbA0X3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 18:29:16 -0500
Date: Wed, 28 Jan 2015 00:29:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Berg Johannes <johannes.berg@intel.com>,
	Clement Perrochaud <clement.perrochaud@nxp.com>
Subject: Re: [PATCH v2 0/2] Add ACPI support for NXP PN544
Message-ID: <20150127232911.GC32667@ribalta.mp.intel.com> (sfid-20150128_002936_063006_D0E10300)
References: <1422270817-10950-1-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422270817-10950-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Mon, Jan 26, 2015 at 01:13:35PM +0200, Robert Dolca wrote:
> This patch set introduces ACPI support for PN544.
> 
> gpio_set_value was replaced with gpio_set_value_cansleep in order
> to allow GPIO access that may sleep. This is particularelly useful
> when GPIO is accessed using busses like I2C, SPI, USB
> 
> Changes since v1:
> 	- Added cover letter
> 	- Removed debug define and Kconfig include
> 	- Minor fixes to patch subjects
> 
> Links to v1:
> 	- http://lkml.iu.edu/hypermail/linux/kernel/1501.1/00943.html
> 	- http://lkml.iu.edu/hypermail/linux/kernel/1501.1/00944.html
> 
> Robert Dolca (2):
>   NFC: PN544: GPIO access that may sleep
>   NFC: Add ACPI support for NXP PN544
Both patches applied, many thanks.

Cheers,
Samuel.
