Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59493 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754692AbXGBQkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2007 12:40:05 -0400
Date: Mon, 2 Jul 2007 18:40:15 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Cohen, Guy" <guy.cohen@intel.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: wmm_acm setting
Message-ID: <20070702184015.44fad5f9@griffin.suse.cz>
In-Reply-To: <D0122E209EBF8D4CAB38EC6A8AF244E502BCD5AC@hasmsx412.ger.corp.intel.com>
References: <D0122E209EBF8D4CAB38EC6A8AF244E502BCD5AC@hasmsx412.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 24 Jun 2007 14:47:40 +0300, Cohen, Guy wrote:
> In mac80211/ieee80211_sta.c, ieee80211_sta_wmm_params(), line ~267, is
> wmm_acm setting for case 1 (BK) and case 0 (BE) right (and not swapped)?

See commit 37c95ceeebd38a3f1f686b8fbf5168672d19f825 in wireless-dev and
the referenced table.

 Jiri

-- 
Jiri Benc
SUSE Labs
