Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26074 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbbJTEuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:50:54 -0400
Date: Tue, 20 Oct 2015 06:50:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcwilink: Drop a useless static qualifier
Message-ID: <20151020045049.GF9764@zurbaran.home> (sfid-20151020_065258_271680_89B19E8A)
References: <1444717864-7109-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444717864-7109-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christophe,

On Tue, Oct 13, 2015 at 08:31:04AM +0200, Christophe JAILLET wrote:
> There is no need to have the 'struct nfcwilink *drv' variable static in the
> probe function.
> It only wastes a few bytes of memory.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/nfc/nfcwilink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks a lot.

Cheers,
Samuel.
