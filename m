Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYIOOkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:40:47 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] Implement basic background scanning
Date: Mon, 15 Sep 2008 16:40:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <200809151429.46638.hschaa@suse.de> <200809151632.00966.mb@bu3sch.de>
In-Reply-To: <200809151632.00966.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151640.43841.hschaa@suse.de> (sfid-20080915_164051_486270_C9D6656F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 15. September 2008 16:32:00 schrieb Michael Buesch:
> On Monday 15 September 2008 14:29:46 Helmut Schaa wrote:
> > -	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
> > +	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN && !local->bg_scanning))
> > {
>
> Does & have precedence over && or the other way around?

AFAIK & has precedence ;) 

> I don't know and I don't want to. Please use parens ;)

Anyway parentheses make it definitively more readable.
