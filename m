Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52193 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYIOOc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:32:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Helmut Schaa <hschaa@suse.de>
Subject: Re: [RFC] Implement basic background scanning
Date: Mon, 15 Sep 2008 16:32:00 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <200809151429.46638.hschaa@suse.de>
In-Reply-To: <200809151429.46638.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151632.00966.mb@bu3sch.de> (sfid-20080915_163232_624456_E15BB8FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008 14:29:46 Helmut Schaa wrote:
> -	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
> +	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN && !local->bg_scanning)) {

Does & have precedence over && or the other way around?
I don't know and I don't want to. Please use parens ;)

-- 
Greetings Michael.
