Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1EIIXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:23:00 -0400
Subject: Re: [PATCH 2/3] mac80211: add support for HW scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304929342.3475.8.camel@jlt3.sipsolutions.net> (sfid-20110509_102230_446918_387B1E88)
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-3-git-send-email-coelho@ti.com>
	 <1304929342.3475.8.camel@jlt3.sipsolutions.net>
	 (sfid-20110509_102230_446918_387B1E88)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:22:58 +0200
Message-ID: <1304929378.3475.9.camel@jlt3.sipsolutions.net> (sfid-20110509_102307_391228_250F40EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 10:22 +0200, Johannes Berg wrote:

> > +TRACE_EVENT(api_sched_scan_stopped,
> > +	TP_PROTO(struct ieee80211_local *local),
> 
> ditto.
> 
> 
> Also -- no API tracers for results/stopped?

Err ... sorry!

johannes

