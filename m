Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22275 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KKQAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 11:00:09 -0500
Subject: Re: [RFC 06/15] mac80211: add support for HW periodic scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "geryk@ti.com" <geryk@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDC0CBA.30201@ti.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com>
	 <1288885537.3659.4.camel@jlt3.sipsolutions.net>
	 <1288987177.25600.15.camel@powerslave>
	 <03639d1a6cc12b36b036145a8c31da33@localhost>  <4CDC0CBA.30201@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 17:59:43 +0200
Message-ID: <1289491183.1606.61.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 16:33 +0100, ext Gery Kahn wrote:
> On 11/05/2010 09:55 PM, Johannes Berg wrote:
> >
> > On Fri, 05 Nov 2010 21:59:37 +0200, Luciano Coelho
> > <luciano.coelho@nokia.com>  wrote:
> >> I think the idea of using background is good.  Something like bg_scan or
> >> something.  The original idea was to call it background scan, but since
> >> wl1271 doesn't support this while connected, I thought calling it
> >> periodic scan would be slightly clearer about that.  Background scan
> >> sounds like you do it while connected (to me at least).
> >
> > Come to think of it though, we also call what we do when connected
> > and trigger a scan manually a "background scan", so that's probably
> > not a good name here.
> >
> > Not sure ... don't really have a good idea right now.

> It may be sched_scan

Hmmm... Scheduled scan is a good idea.  And sched_scan is a clear and
short abbreviation.  What do you think, Johannes?

-- 
Cheers,
Luca.

