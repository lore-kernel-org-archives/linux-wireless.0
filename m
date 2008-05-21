Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbYEUT23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 15:28:29 -0400
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile
	configuration.
From: David Woodhouse <dwmw2@infradead.org>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com>
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
	 <1211396780.21380.368.camel@pmac.infradead.org>
	 <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 20:28:25 +0100
Message-Id: <1211398105.21380.371.camel@pmac.infradead.org> (sfid-20080521_212832_760360_245281C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 12:18 -0700, Javier Cardona wrote:
> You need a live endpoint to send a CMD_802_11_RESET, which you won't
> have if the device did not respond to USB enumeration because it was
> in standalone mode.

Hm, did that behaviour change recently? I'm sure this recovery was
working before.

-- 
dwmw2

