Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59155 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750704AbXB0K2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 05:28:11 -0500
Date: Tue, 27 Feb 2007 11:28:08 +0100
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: rename d80211 -> mac80211
Message-ID: <20070227112808.2fc32c6a@logostar.upir.cz>
In-Reply-To: <20070227032756.GA6569@tuxdriver.com>
References: <20070227032756.GA6569@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Feb 2007 22:27:57 -0500, John W. Linville wrote:
> I apologize if this seems sudden, but I don't really think doing
> it with a lot of warning would have been any better.  So, I made
> the decision and did it.  Please don't complain unless it is just
> unbearable for you. :-)

I think it's indeed a good time for such change now. Thanks for doing that!

When we are at it, I think the module name should be 'mac80211.ko' and not
'80211.ko'. This means renaming of mac80211.c (I suggest mac80211_proto.c or
mac80211_main.c). Does it sounds reasonable? Should I make a patch?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
