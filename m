Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37654 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0IVNOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:14:34 -0400
Date: Wed, 22 Sep 2010 09:02:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Berger <daniel@dat-berger.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Manual Control about Sending ACKs
Message-ID: <20100922130245.GC5515@tuxdriver.com>
References: <20100922123953.67a4fc5e@danmob>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100922123953.67a4fc5e@danmob>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 12:39:53PM +0200, Daniel Berger wrote:

> Thus I deduce ACK sending is completely done in hardware.

Yes, I believe this is the case with all of our supported hardware.

> Is my conclusion and understanding right? Is there any possible solution
> to my problem of sending ACKs manually? Would that be fast enough for
> the SIFS and other stations' ACK timeout?

I suspect you need to be looking at hacking firmware.  You might look
at the open-source ar9170 firmware or the b43-openfwwf project.

Good luck!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
