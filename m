Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbLTRvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 12:51:22 -0500
Date: Sun, 20 Dec 2015 18:51:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Robert Baldyga <r.baldyga@samsung.com>,
	kernel-janitors@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: s3fwrn5: constify s3fwrn5_phy_ops structures
Message-ID: <20151220175118.GB4772@zurbaran.home> (sfid-20151220_185155_097884_DCF0EA75)
References: <1447416281-3357-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447416281-3357-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julia,

On Fri, Nov 13, 2015 at 01:04:41PM +0100, Julia Lawall wrote:
> The s3fwrn5_phy_ops structure is never modified, so declare it as const.
> 
> Done with the help of Coccinelle.
Applied to nfc-next, thanks.

Cheers,
Samuel.
