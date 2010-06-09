Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0FINxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 09:53:10 -0400
Subject: Re: [PATCH v2] mac80211: fix deauth before assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilm2zuqCzc1VZf6r3NfuUnGmxkhYsp6qPKdV6lC@mail.gmail.com>
References: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
	 <1276080986.14580.6.camel@jlt3.sipsolutions.net>
	 <AANLkTilm2zuqCzc1VZf6r3NfuUnGmxkhYsp6qPKdV6lC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 15:53:08 +0200
Message-ID: <1276091588.14580.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 09:51 -0400, Miles Lane wrote:

> > That previous one didn't even apply to the right tree, how did you ever
> > test it? Or did you just fix up the context?
> 
> patching file net/mac80211/mlme.c
> Hunk #1 succeeded at 1722 with fuzz 3 (offset 27 lines).

Oh, so it did actually apply with fuzz, quilt didn't like it here.

johannes

