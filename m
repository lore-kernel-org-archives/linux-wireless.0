Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946367AbXBQBih (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 20:38:37 -0500
Date: Fri, 16 Feb 2007 20:02:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-dev.git breaks wireless extensions
Message-ID: <20070217010221.GA3405@tuxdriver.com>
References: <1171670057.28539.5.camel@dv> <1171670990.3575.50.camel@johannes.berg> <1171673414.28874.4.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171673414.28874.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 16, 2007 at 07:50:14PM -0500, Pavel Roskin wrote:

> Even if I compile D80211 and CFG80211 as modules and load MadWifi, lsmod
> shows that cfg80211 is not loaded, but the iwconfig output is still
> wrong.  Some part of cfg80211 must be compiled into the kernel.

Sounds like the new version of cfg80211's wext compatibility hook
is broken...?

-- 
John W. Linville
linville@tuxdriver.com
