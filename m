Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40719 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbATLGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 06:06:37 -0500
Message-ID: <1421751993.2216.2.camel@sipsolutions.net> (sfid-20150120_120640_633400_9BD4A0F1)
Subject: Re: [RFC 2/2] mac80211: support RX rate statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>
Date: Tue, 20 Jan 2015 12:06:33 +0100
In-Reply-To: <21693.56960.568269.420520@gargle.gargle.HOWL>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	 <1421401708-8123-2-git-send-email-johannes@sipsolutions.net>
	 <21689.49345.803049.938915@gargle.gargle.HOWL>
	 <1421661324.1965.16.camel@sipsolutions.net>
	 <21693.56960.568269.420520@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 10:20 +0530, Sujith Manoharan wrote:

> > If others want to use it for more, I'm certainly not averse to adding
> > it, but it'd also mean adding more userspace API (where it might be a
> > bit strange to add "antennas" to the "rate" since that doesn't impact
> > the actual rate?)
> 
> Having a well-defined API to export statistics seems useful, but
> I guess that can be added later.

Yeah I thought about this - I think we can add more attributes to the
userspace API later as userspace for this must always be prepared to get
multiple messages for what it considers the same rate.

I'm going to have to focus on the TX statistics next, so won't be
working on extending this.

johannes

