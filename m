Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3APWZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:25:27 -0500
Message-ID: <1358375151.15012.24.camel@jlt4.sipsolutions.net> (sfid-20130116_232534_951805_B8AD65A2)
Subject: Re: [PATCH 2/2] mac80211: add encrypt headroom to PERR frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Wed, 16 Jan 2013 23:25:51 +0100
In-Reply-To: <1357752896-17497-2-git-send-email-me@bobcopeland.com> (sfid-20130109_183703_743755_E9A12734)
References: <1357752896-17497-1-git-send-email-me@bobcopeland.com>
	 <1357752896-17497-2-git-send-email-me@bobcopeland.com>
	 (sfid-20130109_183703_743755_E9A12734)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 12:34 -0500, Bob Copeland wrote:
> Mesh PERR action frames are robust and thus may be encrypted, so add
> proper head/tailroom to allow this.  Fixes this warning when operating
> a Mesh STA on ath5k:

Applied both.

johannes

