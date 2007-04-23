Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53810 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753570AbXDWU6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 16:58:17 -0400
Date: Mon, 23 Apr 2007 22:58:21 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 13/13] mac80211: stop all virtual interfaces when master  device goes down
Message-ID: <20070423225821.783ffdc2@griffin.suse.cz>
In-Reply-To: <20070423184814.7029.35852.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<20070423184814.7029.35852.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Apr 2007 14:48:15 -0400, Michael Wu wrote:
> The master device cannot actually veto taking a device down. This patch
> makes all virtual devices go down if the master device goes down.

That fixes my objections for patch #4 :-)

 Jiri

-- 
Jiri Benc
SUSE Labs
