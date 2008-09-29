Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:33004 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751850AbYI2VXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 17:23:03 -0400
Message-ID: <20080929211620.6344.qmail@stuge.se> (sfid-20080929_232306_578319_D3D71081)
Date: Mon, 29 Sep 2008 23:16:20 +0200
From: Peter Stuge <peter@stuge.se>
To: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
References: <48E11F1E.50705@lwfinger.net> <200809292038.37939.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809292038.37939.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Actually, I do know since the very first days of bcm43xx that the
> loop counts are not big enough in some of these loops.

Would it make sense to double check the conditions after the loop?


> But I didn't change it, as it was said the current counts match the
> specs.

Which specs?


//Peter
