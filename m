Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39416 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYFQTDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 15:03:52 -0400
Date: Tue, 17 Jun 2008 22:02:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Message-ID: <20080617190255.GI4974@jm.kir.nu> (sfid-20080617_210354_720874_9EDFF406)
References: <20080617154008.883383150@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080617154008.883383150@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 06:40:08PM +0300, Jouni Malinen wrote:
> This is the first and still quite preliminary version of changes to
> introduce IEEE 802.11w (management frame protection) support into
> mac80211. As such, I'm mainly looking for comments on the current
> design to help me in finalizing and cleaning up the patches.

Thanks for the comments! I think I resolved most of them and made my
current set of patches available at http://w1.fi/mfp/ in order to avoid
having to post them to the list after all minor changes. I'll send new
versions to the list once I get some more known issues resolved and the
patches are closer to being ready to be included in wireless-testing.

-- 
Jouni Malinen                                            PGP id EFC895FA
