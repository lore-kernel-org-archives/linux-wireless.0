Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36161 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0GZSpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 14:45:19 -0400
Date: Mon, 26 Jul 2010 14:37:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Subject: Re: [PATCH] ath5k: disable ASPM
Message-ID: <20100726183735.GF3903@tuxdriver.com>
References: <20100528100901.14580.1322.stgit@fate.lan>
 <1280162044.3492.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280162044.3492.14.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 07:34:04PM +0300, Maxim Levitsky wrote:

> Just want to summarize and finally put that problem to rest.
> 
> Was the patch that removes & sets on CONFIG_PCIEASPM? accepted?
> 
> Is it possible to check that all ath5k pcie devices that must not use
> L0s actually have the 'PCI_EXP_DEVCAP_RBER' disabled (this bit causes
> pcie device be marked as legacy, and ASPM is disabled on it)

http://marc.info/?l=linux-wireless&m=127507083106814&w=2

"Sorry, I meant to this to be RFC patch."

So, I dropped it.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
