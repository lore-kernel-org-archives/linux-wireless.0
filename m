Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-80.dex002.intermedia.net ([64.78.20.165]:24380 "EHLO
	DHOST002-80.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933580AbXCEQoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 11:44:30 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 5 Mar 2007 08:44:17 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [FYI] compiling hostapd against latest wireless-dev
Message-ID: <20070305164417.GA10947@devicescape.com>
References: <1173095902.6131.63.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173095902.6131.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 05, 2007 at 12:58:22PM +0100, Johannes Berg wrote:
> ... isn't really possible at the moment. But you only need to change
> some include paths (to be able to include the
> net/mac80211/mac80211_common.h header!) and apply this change to be able
> to include include/net/mac80211.h into the userspace code.

Which version of hostapd did you try to compile here? The current
development branch does not include net/mac80211.h and the include path
has also been changed from net/d80211 to net/mac80211 in example
configuration.

-- 
Jouni Malinen                                            PGP id EFC895FA
