Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59813 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496Ab2K0Jfd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 04:35:33 -0500
Message-ID: <1354008888.950.62.camel@cumari.coelho.fi> (sfid-20121127_103538_971643_393602E7)
Subject: Re: [PATCH 03/20] wlcore: Allow memory access when the FW crashes
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Yariv <ido@wizery.com>
Date: Tue, 27 Nov 2012 11:34:48 +0200
In-Reply-To: <1353998701-18171-4-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-4-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> From: Ido Yariv <ido@wizery.com>
> 
> When the no_recovery flag is used, the recovery work will not restart
> the FW and the state will not be set to 'on'. To enable post-mortem
> analysis, allow memory access in the 'restarting' state.
> 
> Also, since the FW might not be operational, don't fail the read/write
> operations if elp_wakeup fails.
> 
> Reported-by: Arkady Miasnikov <a-miasnikov@ti.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

This is weird.  This patch is already in (d5560238) and the one here is
actually just part of it and probably won't apply.

--
Luca.

