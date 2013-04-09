Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935211Ab3DIJuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:50:52 -0400
Message-ID: <1365501048.8465.13.camel@jlt4.sipsolutions.net> (sfid-20130409_115059_363044_237E75C9)
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Apr 2013 11:50:48 +0200
In-Reply-To: <1364572823-28071-1-git-send-email-greearb@candelatech.com> (sfid-20130329_170033_026763_9F6C74DD)
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130329_170033_026763_9F6C74DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The sta_info hash is designed to deal with an AP
> with lots of stations associated, or a station interface
> connected to a single AP.

Given your other hash patches, does this even make sense still?

johannes

