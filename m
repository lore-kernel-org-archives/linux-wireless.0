Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from d112a2.x-mailer.de ([212.162.53.4]:52277 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZKMNae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 08:30:34 -0500
From: Karsten Keil <keil@b1-systems.de>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 06/13] pcmcia: Pass struct pcmcia_device to pcmcia_map_mem_page()
Date: Fri, 13 Nov 2009 13:22:17 +0100
Cc: linux-pcmcia@lists.infradead.org, Magnus Damm <damm@opensource.se>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <20091111203303.GA7939@comet.dominikbrodowski.net> <1257971899-9274-6-git-send-email-linux@dominikbrodowski.net>
In-Reply-To: <1257971899-9274-6-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Message-Id: <200911131322.17388.keil@b1-systems.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mittwoch, 11. November 2009 21:38:12 Dominik Brodowski wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> No logic changes, just pass struct pcmcia_device to pcmcia_map_mem_page()
> 
> [linux@dominikbrodowski.net: update to 2.6.31]
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-scsi@vger.kernel.org
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Karsten Keil <isdn@linux-pingi.de>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/char/pcmcia/ipwireless/main.c         |    4 ++--
>  drivers/isdn/hisax/sedlbauer_cs.c             |    2 +-
For  ISDN 

Acked-by: Karsten Keil <keil@b1-systems.de>

