Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2982 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbXJDNjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 09:39:06 -0400
Date: Thu, 4 Oct 2007 09:10:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [NOTE] driver caveat
Message-ID: <20071004131019.GC6037@tuxdriver.com> (sfid-20071004_143920_840662_A0DEB0C9)
References: <1191480634.9898.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191480634.9898.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2007 at 08:50:34AM +0200, Johannes Berg wrote:

> If you've been experiencing bad behaviour with suspend this may be the
> cause, instead of working around in the driver I suggest you implement
> proper suspend/resume hooks in mac80211 for drivers to call ;)

Proper support for suspend/resume in mac80211 seems to be an issue
that could use some TLC.  Anyone up for the challenge?

John
-- 
John W. Linville
linville@tuxdriver.com
