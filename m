Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759626Ab0JFSQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:16:21 -0400
Subject: Re: Crash in cfg80211_unlink_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CACBB14.1090507@candelatech.com>
References: <4CACB1D1.7090900@candelatech.com>
	 <1286388245.3655.392.camel@jlt3.sipsolutions.net>
	 <4CACBB14.1090507@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:16:20 +0200
Message-ID: <1286388980.3655.395.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 11:08 -0700, Ben Greear wrote:

> > I need to analyse the refcounting here again and in more detail, but in
> > the meantime can you try below patch?
> 
> Yes, will do so and let you know the results.

Please try the new version, and let me know. I should submit this ASAP.

johannes

