Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2LKUBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 15:01:44 -0500
Message-ID: <1355256114.9819.19.camel@jlt4.sipsolutions.net> (sfid-20121211_210148_077376_5345E537)
Subject: Re: [PATCH] mac80211: fix ibss scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Dec 2012 21:01:54 +0100
In-Reply-To: <20121211094822.GA3262@redhat.com>
References: <20121211094822.GA3262@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 10:48 +0100, Stanislaw Gruszka wrote:
> Do not scan on no-IBSS and disabled channels in IBSS mode. Doing this
> can trigger Microcode errors on iwlwifi and iwlegacy drivers.

I guess this makes sense regardless of the microcode errors, applied.
(Are you using SW scan?)

FWIW, I'm applying everything to my mac80211-next tree right now. Once
the merge window closes I'll rebase all my trees and sort patches
correctly.

johannes

