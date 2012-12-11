Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2LKTxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:53:39 -0500
Message-ID: <1355255636.9819.15.camel@jlt4.sipsolutions.net> (sfid-20121211_205341_667406_042E1844)
Subject: Re: [RFCv3 0/5] mesh power save - basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 11 Dec 2012 20:53:56 +0100
In-Reply-To: <1354918443-3076-1-git-send-email-marco@cozybit.com> (sfid-20121207_231440_038670_8F9DFF9D)
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
	 (sfid-20121207_231440_038670_8F9DFF9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 14:13 -0800, Marco Porsch wrote:
> The following commits cover the basic subset of functions, that each mesh node
> must support to communicate in the presence of power saving nodes.
> The current patchset does not implement any actual power savings yet (no
> hardware configuration, no doze state).

Looks fine I guess, although it seems the order should be more like 3,
1, 2+5 in one, 4?

johannes

