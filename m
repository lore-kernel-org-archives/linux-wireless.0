Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3BZUQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:16:55 -0500
Message-ID: <1361909805.8440.5.camel@jlt4.sipsolutions.net> (sfid-20130226_211659_052564_6C898E7E)
Subject: Re: [PATCH] mac80211: Ensure off-channel frames don't get queued
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Fabio Rossi <rossi.f@inwind.it>, linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 21:16:45 +0100
In-Reply-To: <1361825885-13520-1-git-send-email-seth.forshee@canonical.com>
References: <20130225192629.GH13296@thinkpad-t410>
	 <1361825885-13520-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 14:58 -0600, Seth Forshee wrote:
> Commit 6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue
> handling during scans) contains a bug that causes off-channel frames to
> get queued when they should be handed down to the driver for transmit.
> Prevent this from happening.
> 
> Reported-by: Fabio Rossi <rossi.f@inwind.it>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
> 
> Fabio, this patch should fix the problem. Can you verify?
> 
> Johannes, this prevents the off-channel frames from getting queued
> without affecting the fast path. It does however make the indentation
> awfully deep ...

Ugh .. I do see the bug, but the indentation is crap. I'll apply this
anyway, and then we can sort it out later.

johannes


