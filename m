Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54489 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZETVfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 17:35:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : under high load, ack are lost
Date: Wed, 20 May 2009 23:34:40 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090517T085823-487@post.gmane.org> <loom.20090520T203218-265@post.gmane.org> <loom.20090520T210546-24@post.gmane.org>
In-Reply-To: <loom.20090520T210546-24@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905202334.40841.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 May 2009 23:09:47 matthieu castet wrote:
> I see also some period were the AP seem to drop all packet.
> I am wondering if it can be due to slow recalibration.
> Do you now how much take calibration were mac is down ?

Something like 30/40/50 milliseconds. I don't know. Somewhere in that range.

But I think it doesn't drop packets due to recal. I think it's simply
because the b43 PHY code is completely broken.

-- 
Greetings, Michael.
