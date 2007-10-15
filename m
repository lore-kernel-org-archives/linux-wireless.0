Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:49539 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408AbXJOTbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 15:31:20 -0400
From: Christian Hoffmann <email@christianhoffmann.info>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: b43 with upstream-davem stacktrace
Date: Mon, 15 Oct 2007 21:30:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <200710131823.33420.email@christianhoffmann.info> <1192354978.4770.100.camel@johannes.berg> <1192439126.5684.13.camel@localhost.localdomain>
In-Reply-To: <1192439126.5684.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710152130.24950.email@christianhoffmann.info> (sfid-20071015_203124_015190_99B0EA6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 October 2007 11:05:26 am Richard Purdie wrote:
> It appears to be having a problem in the strcmp in
> led_trigger_set_default() which is odd. Code above that checks if one of
> the options is NULL so all I can think it either the default_trigger
> string being passed in is invalid or there is a trigger with an invalid
> name registered with the system.

It's a SMP kernel, but running on a single CPU (single core AMD Turion).

Chris
