Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34055
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab0GWSsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 14:48:00 -0400
Date: Fri, 23 Jul 2010 11:48:16 -0700 (PDT)
Message-Id: <20100723.114816.193692123.davem@davemloft.net>
To: linux@dominikbrodowski.net
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, laforge@gnumonks.org,
	linux-mtd@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] pcmcia: remove cs_types.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279874305-21191-6-git-send-email-linux@dominikbrodowski.net>
References: <20100723083726.GA20947@comet.dominikbrodowski.net>
	<1279874305-21191-6-git-send-email-linux@dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Fri, 23 Jul 2010 10:38:25 +0200

> Remove cs_types.h which is no longer needed: Most definitions aren't
> used at all, a few can be made away with, and two remaining definitions
> (typedefs, unfortunatley) may be moved to more specific places.
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

Acked-by: David S. Miller <davem@davemloft.net>
