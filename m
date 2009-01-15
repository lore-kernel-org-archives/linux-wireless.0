Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZAOXRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:49 -0500
Date: Thu, 15 Jan 2009 18:17:43 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [b43] opensource firmware
Message-ID: <20090115231743.GC7488@bombadil.infradead.org> (sfid-20090116_001809_729155_A65183A0)
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <200901151637.58196.mb@bu3sch.de> <496F5D4F.3020805@lwfinger.net> <200901151709.49811.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901151709.49811.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2009 at 05:09:49PM +0100, Michael Buesch wrote:
> Already implemented here:
> http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch
> I just need to fix a leak in an error path before pushing that upstream.
> 

Groovy, I had cooked a similar patch for Fedora but haven't gotten
around to packaging up the fw yet. Will sub in yours.

cheers, Kyle
