Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab1F0S6C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 14:58:02 -0400
Subject: Re: [PATCH 18/19] iwlwifi: remove unnecessary read of
 PCI_CAP_ID_EXP
From: wwguy <wey-yi.w.guy@intel.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
References: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 11:54:08 -0700
Message-ID: <1309200848.15221.3.camel@wwguy-ubuntu> (sfid-20110627_205810_238992_8A107371)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-27 at 10:49 -0700, Jon Mason wrote:
> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.
> 
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 


