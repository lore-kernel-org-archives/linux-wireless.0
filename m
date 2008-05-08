Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4973 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYEHUbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 16:31:25 -0400
Date: Thu, 8 May 2008 16:04:34 -0400
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
Subject: Re: [patch 11/16] b43: Fix some TX/RX locking issues
Message-ID: <20080508200434.GC9176@tuxdriver.com> (sfid-20080508_223024_404566_A46B9007)
References: <20080508173436.454278564@mini.kroah.org> <20080508174221.GL855@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080508174221.GL855@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 08, 2008 at 10:42:21AM -0700, Greg KH wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Michael Buesch <mb@bu3sch.de>
> 
> commit 21a75d7788f4e29b6c6d28e08f9f0310c4de828d upstream.
> 
> This fixes some TX/RX related locking issues.
> With this patch applied, some of the PHY transmission errors are fixed.

ACK

-- 
John W. Linville
linville@tuxdriver.com
