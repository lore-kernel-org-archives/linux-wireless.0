Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45165 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbZJ0TbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 15:31:16 -0400
Date: Tue, 27 Oct 2009 15:28:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] pcmcia: use pcmcia_loop_config in misc pcmcia
	drivers
Message-ID: <20091027192832.GD15566@tuxdriver.com>
References: <1255907255-28297-1-git-send-email-linux@dominikbrodowski.net> <1255907255-28297-2-git-send-email-linux@dominikbrodowski.net> <1255907255-28297-3-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255907255-28297-3-git-send-email-linux@dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2009 at 01:07:29AM +0200, Dominik Brodowski wrote:
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

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
