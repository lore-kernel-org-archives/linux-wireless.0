Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4488 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYEHUCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 16:02:42 -0400
Date: Thu, 8 May 2008 15:38:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>
Subject: Re: [patch 08/16] b43: Fix dual-PHY devices
Message-ID: <20080508193803.GB9176@tuxdriver.com> (sfid-20080508_220142_955655_1E5E0242)
References: <20080508173436.454278564@mini.kroah.org> <20080508174214.GI855@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080508174214.GI855@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 08, 2008 at 10:42:14AM -0700, Greg KH wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Michael Buesch <mb@bu3sch.de>
> 
> commit 2e35af143a1380173ba292e48e9b4913ef16b4ee upstream
> 
> This fixes operation of dual-PHY (A/B/G) devices.
> Do not anounce the A-PHY to mac80211, as that's not supported, yet.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

ACK

-- 
John W. Linville
linville@tuxdriver.com
