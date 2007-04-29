Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57049 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933273AbXD2OWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 10:22:04 -0400
Date: Sun, 29 Apr 2007 16:22:02 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove passive_scan handler
Message-ID: <20070429162202.07bfa98a@logostar.upir.cz>
In-Reply-To: <200704291602.46275.IvDoorn@gmail.com>
References: <20070429155736.322076b3@logostar.upir.cz>
	<200704291602.46275.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Apr 2007 16:02:46 +0200, Ivo van Doorn wrote:
> Ehm, please check my rt2x00 git pull request of yesterday. ;)
> To quote myself:
> "Perhaps the most interesting thing would be the removal
> of passive scan support, because it was a purely software based
> solution that (if really required) could best be resolved in mac80211
> rather then the driver for devices that don't support such a thing in the
> hardware."

Didn't notice that :-)

> When John pulls the upstream branch of rt2x00 git, passive scanning will
> already be removed. :)

Nice. Thanks.

 Jiri

-- 
Jiri Benc
SUSE Labs
