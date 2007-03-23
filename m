Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36254 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752069AbXCWSE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:04:58 -0400
Date: Fri, 23 Mar 2007 19:04:56 +0100
From: Jiri Benc <jbenc@suse.cz>
To: johannes@sipsolutions.net
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH (v3) 0/4] move everything in mac80211 from sysfs to  debugfs
Message-ID: <20070323190456.7c715dfe@griffin.suse.cz>
In-Reply-To: <20070307164531.910923000@sipsolutions.net>
References: <20070307164531.910923000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 07 Mar 2007 17:45:31 +0100, johannes@sipsolutions.net wrote:
> In order to not export internal details via sysfs (which is a
> userspace ABI) this patch series moves everything from sysfs
> into debugfs.

Applied to my tree, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
