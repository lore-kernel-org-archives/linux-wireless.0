Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4590 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbYDHTBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 15:01:46 -0400
Date: Tue, 8 Apr 2008 14:35:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in
	ieee80211_sta_expire
Message-ID: <20080408183556.GC8183@tuxdriver.com> (sfid-20080408_200149_941516_4E90517E)
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 07, 2008 at 09:53:48PM +0200, Jiri Slaby wrote:
> Hi,
> 
> it's against -mm, what's current mac80211 git tree? It seems that
> -mm has fresher material, than wireless-2.6...

As it should.  The wireless-2.6 tree is for feeding the linux-2.6 tree
(by way of the net-2.6 tree).  Similarly, wireless-2.6.26 feeds -mm
by way of the net-2.6.26 tree.

Please use the wireless-testing tree for development, as it contains
both sets of patches (fixes for the current release and updates for the
future) as well as a few extras (like drivers still in development).
Plus it is somewhat more stable, being based off the most a recent
-rc release rather than just whatever someone last pulled.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
