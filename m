Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34174 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031341AbXD2Tzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 15:55:33 -0400
Date: Sun, 29 Apr 2007 21:55:28 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: "Stable" branch of mac80211
Message-ID: <20070429215528.02c51cf9@logostar.upir.cz>
In-Reply-To: <200704291414.19963.flamingice@sourmilk.net>
References: <20070429194855.451b9e7c@logostar.upir.cz>
	<200704291414.19963.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Apr 2007 14:14:14 -0400, Michael Wu wrote:
> wireless-dev has been updated recently. One of the conflicts can be resolved 
> easily. There's also an API change which conflicts with the qdisc fixes 
> because tcf_destroy is no longer exported. A patch for that is attached.

I folded the patch into the qdisc fix patch and rebased my tree (all
branches).

I also ensured the previously misapplied radiotap patch is now applied
correctly and dropped the "move radiotap removal code to right function"
patch.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
