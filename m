Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51315 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760080Ab2EPSRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 14:17:48 -0400
Date: Wed, 16 May 2012 14:10:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: add __printf argument checking
Message-ID: <20120516181010.GB28167@tuxdriver.com> (sfid-20120516_201828_817548_096444BE)
References: <1337086877.4546.4.camel@jlt3.sipsolutions.net>
 <20120516174121.GF3508@tuxdriver.com>
 <1337190928.18519.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1337190928.18519.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 07:55:28PM +0200, Johannes Berg wrote:
> On Wed, 2012-05-16 at 13:41 -0400, John W. Linville wrote:
> > This one causes a few warnings here -- can we fix those at the same time as we add this?
> > 
> >   CC      drivers/net/wireless/iwlwifi/iwl-agn-sta.o
> > drivers/net/wireless/iwlwifi/iwl-agn-sta.c: In function ‘iwl_sta_calc_ht_flags’:
> > drivers/net/wireless/iwlwifi/iwl-agn-sta.c:238:2: warning: too few arguments for format
> > 
> >   CC      drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.o
> > drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: In function ‘iwl_rx_handle’:
> > drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: format ‘%d’ expects type ‘int’, but argument 6 has type ‘struct iwl_rx_mem_buffer *’
> > drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: too few arguments for format
> 
> I think they were gone by the time I did this, but you said you had to
> skip a few patches (some of which fixed such bugs) as they didn't apply.

Ah, that could be true.  I'll bug you again later if it comes back... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
