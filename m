Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42151 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:38:58 -0400
Date: Tue, 25 Jun 2013 23:38:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] wlcore: use irq_flags in pdata instead of hiding
 it behing a quirk
Message-ID: <20130626063855.GN5523@atomide.com> (sfid-20130626_083900_349777_DB66D95D)
References: <1372192406-29430-1-git-send-email-coelho@ti.com>
 <1372192406-29430-3-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372192406-29430-3-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luciano Coelho <coelho@ti.com> [130625 13:39]:
> The platform_quirk element in the platform data was used to change the
> way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
> the irqflags used and treat edge trigger differently from the rest.
> 
> Instead of hiding this irq flag setting behind the quirk, export the
> whole irq_flags element and let the board file define what to use.
> This will be more meaningful than driver-specific quirks when we
> switch to DT.
> 

Acked-by: Tony Lindgren <tony@atomide.com>

> Cc: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
