Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38177 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753477AbdIDLnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 07:43:05 -0400
Date: Mon, 4 Sep 2017 13:43:02 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: Luca Coelho <luca@coelho.fi>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwifi@intel.com, rui.zhang@intel.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, david.weinehall@intel.com,
        johannes.berg@intel.com, kvalo@codeaurora.org,
        sara.sharon@intel.com, emmanuel.grumbach@intel.com
Subject: Re: [PATCH v2] iwlwifi: pcie: move rx workqueue initialization to
 iwl_trans_pcie_alloc()
In-Reply-To: <1503604818.15969.433.camel@coelho.fi>
Message-ID: <nycvar.YFH.7.76.1709041342130.18231@jbgna.fhfr.qr> (sfid-20170904_134323_344828_CAB9D8E1)
References: <alpine.LSU.2.20.1708171537380.3581@cbobk.fhfr.pm>   <20170822073729.4856-1-luca@coelho.fi>  <1503554432.15969.415.camel@coelho.fi>  <alpine.LSU.2.20.1708242153000.3581@cbobk.fhfr.pm> <1503604818.15969.433.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 24 Aug 2017, Luca Coelho wrote:

> > looks like a correct fix to me, so feel free to add
> > 
> > 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > I'll be able to provide my Tested-by: eventually only in ~10 days.
> 
> 
> Kalle already picked it up in wireless-drivers and this should make it's
> way to 4.13-rc7 (we hope).
> 
> In any case, thanks for reporting and the help debugging it.

I know it's pretty late for this to be added to the commit, but I don't 
want this to be left in the void, so for the sake of completness:

	Tested-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
