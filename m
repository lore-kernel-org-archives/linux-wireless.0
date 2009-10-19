Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZJSNpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 09:45:06 -0400
Date: Mon, 19 Oct 2009 15:45:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Sterba <dsterba@suse.cz>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] pcmcia: use pcmcia_loop_config in misc pcmcia
 drivers
In-Reply-To: <1255907255-28297-3-git-send-email-linux@dominikbrodowski.net>
Message-ID: <alpine.LSU.2.00.0910191544350.8582@wotan.suse.de>
References: <1255907255-28297-1-git-send-email-linux@dominikbrodowski.net> <1255907255-28297-2-git-send-email-linux@dominikbrodowski.net> <1255907255-28297-3-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Oct 2009, Dominik Brodowski wrote:

> Use pcmcia_loop_config() in a few drivers missed during the first
> round. On fmvj18x_cs.c it -- strangely -- only requries us to set
> conf.ConfigIndex, which is done by the core, so include an empty
> loop function which returns 0 unconditionally.
> 
> CC: David S. Miller <davem@davemloft.net>
> CC: John W. Linville <linville@tuxdriver.com>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: David Sterba <dsterba@suse.cz>
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/char/pcmcia/ipwireless/main.c |  103 +++++++--------------------------

For the ipwireless part

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
