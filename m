Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:8267 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762852AbYDRVEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:04:34 -0400
Received: by py-out-1112.google.com with SMTP id u52so992669pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 14:04:31 -0700 (PDT)
Subject: Re: [patch 1/7] mac80211: tkipc.c michael.c use kernel bit
	rotation helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: akpm@linux-foundation.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jbenc@suse.cz, joe@perches.com, johannes@sipsolutions.net
In-Reply-To: <200804182059.m3IKxmv4015589@imap1.linux-foundation.org>
References: <200804182059.m3IKxmv4015589@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 14:04:44 -0700
Message-Id: <1208552684.10414.1.camel@brick> (sfid-20080418_220913_341474_7339309F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-18 at 13:59 -0700, akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Use ror16, ror32, rol32 instead of a private helper.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Jiri Benc <jbenc@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Andrew, I've since reworked this series to use the new unaligned
helpers, johannes has that series and you can drop these 7 patches.

Harvey

