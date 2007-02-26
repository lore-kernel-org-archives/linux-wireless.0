Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3574 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbXBZDGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Feb 2007 22:06:00 -0500
Date: Sun, 25 Feb 2007 20:18:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] d80211: Split antenna selection into TX and RX antenna
Message-ID: <20070226011810.GC4936@tuxdriver.com>
References: <200702211702.48001.IvDoorn@gmail.com> <20070223172815.359080e8@griffin.suse.cz> <200702231739.04950.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702231739.04950.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 23, 2007 at 05:39:04PM +0100, Ivo van Doorn wrote:

> Sorry about that, I had renamed rx_params to rx_status in my cvs tree and hadn't set that
> correctly to the git tree yet. I'll try to update rt2x00 inside wireless-dev as soon as possible,
> but in the mean time here is the correct patch.

Since you brought it up... :-)

It would be a big help if rt2x00 could keep upstream in-sync with your
current developments.  FWIW, I expect wireless-dev to get picked-up
in -mm soon, and Fedora has it in rawhide already.  So, it is in your
own best interest to make sure that we have the latest fixes here,
unless you want to support two different versions... :-)

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
