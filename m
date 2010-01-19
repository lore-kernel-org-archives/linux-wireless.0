Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55787 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0ASWA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 17:00:27 -0500
Date: Tue, 19 Jan 2010 16:55:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 5/5 V2] b43: N-PHY: silence warnings, add missing call
Message-ID: <20100119215528.GB3078@tuxdriver.com>
References: <op.u6o9unx49lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <op.u6o9unx49lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2010 at 12:21:49AM +0100, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> New patch I didn't include earlier.

Rafał,

I just applied this 5-patch series and the preceding 7-patch series,
and I had to fixup every single one manually due to the apparently
busted mailer you are using.

	User-Agent: Opera Mail/10.10 (Linux)

The only reason I went to this trouble is because a) I want the
N-phy stuff and b) you sent small, manageable patches.  But don't
misunderstand -- I have no intention of continuing to fix these
manually.

Learn to use "git send-email" or find some other mailer to send
your patches -- I recommend Mutt.  In any case, do not expect your
patches to get merged unless in the future unless you can rectify
this situation at your end.  I just don't have the bandwidth for
dealing with crap like this.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
