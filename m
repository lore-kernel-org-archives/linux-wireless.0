Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRBmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:42:53 -0400
Message-ID: <1334713339.3725.19.camel@jlt3.sipsolutions.net> (sfid-20120418_034255_380637_7FA84E97)
Subject: Re: [PATCH v2 6/6] mac80211: Add sta_state to ethtool stats.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:42:19 -0700
In-Reply-To: <1334684807-14026-7-git-send-email-greearb@candelatech.com> (sfid-20120417_194724_045118_B502EAFF)
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
	 <1334684807-14026-7-git-send-email-greearb@candelatech.com>
	 (sfid-20120417_194724_045118_B502EAFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Helps to know how the station is doing in it's association
> attempt.

Since you keep resending, why not roll this into another patch?

Also you could put the code into the right place so patch 5 doesn't move
it all.

johannes

