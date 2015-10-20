Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44390 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbbJTEua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:50:30 -0400
Date: Tue, 20 Oct 2015 06:50:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Charles Gorand <charles.gorand@effinnov.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: nxp-nci: constify nxp_nci_phy_ops structure
Message-ID: <20151020045024.GD9764@zurbaran.home> (sfid-20151020_065046_331071_7F38838F)
References: <1444562653-4914-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444562653-4914-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julia,

On Sun, Oct 11, 2015 at 01:24:13PM +0200, Julia Lawall wrote:
> The only instance of a nxp_nci_phy_ops structure is never modified.  Thus
> the declaration of the structure and all references to the structure type
> can be made const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/nfc/nxp-nci/core.c    |    3 ++-
>  drivers/nfc/nxp-nci/i2c.c     |    2 +-
>  drivers/nfc/nxp-nci/nxp-nci.h |    5 +++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
