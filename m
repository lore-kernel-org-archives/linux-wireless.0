Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57791 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZG0SqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:46:03 -0400
Date: Mon, 27 Jul 2009 14:43:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Subject: Re: [PATCH v2 12/14] iwlwifi: debugFs to enable/disable HT40
	support
Message-ID: <20090727184339.GA8823@tuxdriver.com>
References: <1248705439.23314.24.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1248705439.23314.24.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 07:37:19AM -0700, Guy, Wey-Yi wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Add debugfs file to enable/disable HT40(40MHz) channel support.
> By default, 40MHz is supported if AP can support the function.
> 
> By echo "1" to "disable_ht40_mode" file, iwlwifi driver will disable the
> 40MHz support and only allow 20MHz channel.
> 
> Because the information exchange happen during association time,
> so enable/disable fat channel only can be performed when it is not
> associated with AP.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> v2: namene change from "fat" to "HT40"

This doesn't seem to apply whether or not I revert "iwlwifi: debugFs
to enable/disable 40MHz channel support" before trying...  What did
you base it upon?

For the record, if you repost this please assume that I will revert
"iwlwifi: debugFs to enable/disable 40MHz channel support" before
applying this one.  Alternatively, feel free to post a patch that
merely changes the references from "fat" to "ht40" or whatever on
top of the other patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
