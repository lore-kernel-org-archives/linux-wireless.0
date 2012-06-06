Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2FFI7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:59:38 -0400
Message-ID: <1338973176.4513.32.camel@jlt3.sipsolutions.net> (sfid-20120606_105941_279098_859C8A80)
Subject: Re: [RFC 08/14] mac80211: refactor virtual monitor code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:59:36 +0200
In-Reply-To: <1338973137.4513.31.camel@jlt3.sipsolutions.net> (sfid-20120606_105902_447658_1C22AD9B)
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-9-git-send-email-michal.kazior@tieto.com>
	 <1338973137.4513.31.camel@jlt3.sipsolutions.net>
	 (sfid-20120606_105902_447658_1C22AD9B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 10:58 +0200, Johannes Berg wrote:
> On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> > Use cfg80211 the new .set_monitor_enabled instead
> > of tracking it inside mac80211.
> 
> I .. think I missed the introduction of set_monitor_enabled, where was
> it?

Nevermind, I skipped patch 7 -- because somebody else had replied it had
moved up in my email list.

johannes

