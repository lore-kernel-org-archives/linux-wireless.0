Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbbA3AIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 19:08:43 -0500
Date: Fri, 30 Jan 2015 01:08:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: clement.perrochaud@effinnov.com
Cc: linux-nfc@lists.01.org,
	=?iso-8859-1?Q?Cl=E9ment?= Perrochaud
	<clement.perrochaud@nxp.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] NFC: nxp-nci: Allow module removal during download
Message-ID: <20150130000833.GC20998@ribalta.ger.corp.intel.com> (sfid-20150130_010902_394482_F472622A)
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
 <1421940460-14049-5-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1421940460-14049-5-git-send-email-clement.perrochaud@effinnov.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clement,

On Thu, Jan 22, 2015 at 04:27:40PM +0100, clement.perrochaud@effinnov.com wrote:
> From: Clément Perrochaud <clement.perrochaud@nxp.com>
> 
> Signed-off-by: Clément Perrochaud <clement.perrochaud@nxp.com>
> Signed-off-by: Clément Perrochaud <clement.perrochaud@effinnov.com>
> ---
>  drivers/nfc/nxp-nci/core.c     | 7 +++----
>  drivers/nfc/nxp-nci/firmware.c | 9 ++++++---
>  2 files changed, 9 insertions(+), 7 deletions(-)
Please squash that one into the first patch.

Cheers,
Samuel.
