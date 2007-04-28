Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42219 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030800AbXD1WQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 18:16:54 -0400
Date: Sun, 29 Apr 2007 00:16:48 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 1/7] mac80211: move radiotap removal code to right  function
Message-ID: <20070429001648.6dca865d@logostar.upir.cz>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Apr 2007 12:36:01 -0400, Michael Wu wrote:
> A chunk from the radiotap patch landed in the wrong function when the patch
> was being updated. This moves it to the right function.

Oops. Too narrow context, I guess. Thanks for noticing it.

All seven patches applied.

Thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
