Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41940 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1LSUPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 15:15:36 -0500
Date: Mon, 19 Dec 2011 15:13:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Yogesh Ashok Powar <yogesh.powar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH V2] mac80211: Fixing sparse warning at sta_info.c
Message-ID: <20111219201346.GD31462@tuxdriver.com> (sfid-20111219_211539_542344_4375D3DC)
References: <82612>
 <20111216061715.GA11190@dugs>
 <20111219193957.GC31462@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111219193957.GC31462@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 02:39:57PM -0500, John W. Linville wrote:
> Applying: mac80211: Fixing sparse warning at sta_info.c
> error: patch failed: net/mac80211/sta_info.c:974
> error: net/mac80211/sta_info.c: patch does not apply
> 
> What tree did you use as a base for your patch?

NM -- it was simple to fix-up, even if 'git apply' couldn't figure
it out...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
