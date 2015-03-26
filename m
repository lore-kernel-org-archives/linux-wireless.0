Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbbCZKV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 06:21:56 -0400
Date: Thu, 26 Mar 2015 11:21:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: clement.perrochaud@effinnov.com
Cc: linux-nfc@lists.01.org, sunil.jogi@nxp.com, jerome.pele@nxp.com,
	Charles.Gorand-Effinnov@nxp.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org,
	clement.perrochaud@nxp.com, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	anda-maria.nicolae@intel.com
Subject: Re: [PATCH v2 0/3] NFC: nxp-nci: Add support for NXP-NCI NFC
 controllers
Message-ID: <20150326102148.GA18666@ribalta.ger.corp.intel.com> (sfid-20150326_112220_344612_B75B20B9)
References: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clément,

On Mon, Mar 09, 2015 at 11:12:02AM +0100, clement.perrochaud@effinnov.com wrote:
> From: Clément Perrochaud <clement.perrochaud@effinnov.com>
> 
> This patch brings support for the NXP-NCI NFC controllers family.
> 
> It has been successfully tested on the following SoC boards:
>  - BeagleBone
>  - BeagleBone Black
>  - Raspberry Pi B
>  - Raspberry Pi B+
> 
> The submission is broken into three patches:
>  - The first one adds firmware download support to NCI ;
>  - The second one adds the NXP-NCI driver's core ;
>  - The third one adds I2C support to the driver.
All 3 patches applied to nfc-next, many thanks.

Cheers,
Samuel.
