Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35991 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755364AbXEDOqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 10:46:08 -0400
Date: Fri, 4 May 2007 16:45:59 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH v2] mac80211: prevent a wme_qdiscop_init BUG on other  devices
Message-ID: <20070504164559.730fd662@griffin.suse.cz>
In-Reply-To: <20070504010231.5274.99328.stgit@magic.sourmilk.net>
References: <20070504010231.5274.99328.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 May 2007 21:02:31 -0400, Michael Wu wrote:
> This prevents a BUG if the ieee80211 qdisc is being registered on a net dev
> without ieee80211_ptr set. It also ensures the device is a mac80211 device.

Applied, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
