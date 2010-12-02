Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LBRqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:46:10 -0500
Subject: Re: [PATCH] mac80211: Fix BUG in pskb_expand_head when
 transmitting shared skbs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291311849-13086-1-git-send-email-helmut.schaa@googlemail.com>
References: <1291311849-13086-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 18:46:08 +0100
Message-ID: <1291311968.3481.52.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 18:44 +0100, Helmut Schaa wrote:
> mac80211 doesn't handle shared skbs correctly at the moment. As a result
> a possible resize can trigger a BUG in pskb_expand_head.

Could monitor_start_xmit have the same issue?

johannes

