Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1JGQUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:20:43 -0400
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Shahar Lev <shahar@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1318004245-18347-1-git-send-email-shahar@wizery.com> (sfid-20111007_181755_157242_AF6DA13F)
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
	 (sfid-20111007_181755_157242_AF6DA13F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 18:20:34 +0200
Message-ID: <1318004434.3988.16.camel@jlt3.sipsolutions.net> (sfid-20111007_182046_863418_CF3C1236)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 18:17 +0200, Shahar Lev wrote:
> mac80211 sets the carrier on an IBSS interface even when no network is
> joined.

Maybe you should also change that? :-)

johannes


