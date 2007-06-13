Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56463 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755315AbXFMKwt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 06:52:49 -0400
Date: Wed, 13 Jun 2007 12:52:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613105243.GA15368@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <466DA14D.6080309@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> Forgot to include changes outside of drivers/net/wireless/mac80211/iwlwifi/
> 
> Zhu Yi is the maintainer for the iwlwifi driver (Cc: on this email)

Thanks.

> >>
> >> be listed as a maintainer?
> >>
> >> Kconfig mentions...
> >>
> >>           See <file:Documentation/networking/README.iwlwifi> for
> >>           information on the capabilities currently enabled in this
> >>           driver and for tips for debugging issues and problems.
> 
> We'll remove that from the Kconfig until we get the document updated
> to reflect the current status.

Actually, It is probably better to just include the docs.

(I'll test the patch now).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
