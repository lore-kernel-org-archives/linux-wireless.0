Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYEUITZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 04:19:25 -0400
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile
	configuration.
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Javier Cardona <javier@cozybit.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <200805210907.21250.hs4233@mail.mn-solutions.de>
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <200805201007.59746.hs4233@mail.mn-solutions.de>
	 <445f43ac0805202252v2fc8757ax5a43ddce8188ed61@mail.gmail.com>
	 <200805210907.21250.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 21 May 2008 09:19:21 +0100
Message-Id: <1211357961.21380.287.camel@pmac.infradead.org> (sfid-20080521_101943_817551_05C7F413)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 09:07 +0200, Holger Schurig wrote:
> Ahh, ok. And since ethX can't produce mesh beacons, then mesh_ie 
> entry belongs then to mshX's sysfs-entry, right?

I moved it there already.

-- 
dwmw2

