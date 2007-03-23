Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38504 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932425AbXCWUfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:35:22 -0400
Date: Fri, 23 Mar 2007 21:35:18 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Linville@suse.cz,
	"John" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>
Subject: Re: [PATCH v4] d80211: Add software sequence support
Message-ID: <20070323213518.33a1a8b1@griffin.suse.cz>
In-Reply-To: <200703232042.53005.mb@bu3sch.de>
References: <200703232021.29700.IvDoorn@gmail.com>
	<200703232042.53005.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 20:42:52 +0100, Michael Buesch wrote:
> On Friday 23 March 2007 20:21, Ivo van Doorn wrote:
> > Most hardware can keep track of sequence numbers themselves,
> > unfortunately *most* doesn't cover all devices. ;)
> > This patch will keep track of the (per-bss) sequence number
> > if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.
> 
> You should update the description as well. ;)

Applied (with a description shortened by a last line). 

Thanks for the patch,

 Jiri

-- 
Jiri Benc
SUSE Labs
