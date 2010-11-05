Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0KETzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:55:05 -0400
To: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC 06/15] mac80211: add support for HW periodic scan
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Nov 2010 20:55:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <1288987177.25600.15.camel@powerslave>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com> <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com> <1288885537.3659.4.camel@jlt3.sipsolutions.net> <1288987177.25600.15.camel@powerslave>
Message-ID: <03639d1a6cc12b36b036145a8c31da33@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 05 Nov 2010 21:59:37 +0200, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> I think the idea of using background is good.  Something like bg_scan or
> something.  The original idea was to call it background scan, but since
> wl1271 doesn't support this while connected, I thought calling it
> periodic scan would be slightly clearer about that.  Background scan
> sounds like you do it while connected (to me at least).

Come to think of it though, we also call what we do when connected
and trigger a scan manually a "background scan", so that's probably
not a good name here.

Not sure ... don't really have a good idea right now.

johannes
