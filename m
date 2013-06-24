Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3FXOAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 10:00:15 -0400
Message-ID: <1372082410.8439.7.camel@jlt4.sipsolutions.net> (sfid-20130624_160018_865844_BC7C8C96)
Subject: Re: [PATCH 1/2] mac80211: allow self-protected frame tx without sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>, marco@cozybit.com,
	Bob Copeland <me@bobcopeland.com>
Date: Mon, 24 Jun 2013 16:00:10 +0200
In-Reply-To: <1371797459-16585-1-git-send-email-thomas@cozybit.com> (sfid-20130621_085347_851012_3B38C223)
References: <1371797459-16585-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130621_085347_851012_3B38C223)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-20 at 23:50 -0700, Thomas Pedersen wrote:
> Useful for userspace mesh to authenticate and peer without
> a station entry, since both steps may fail anyway.

Both patches applied.

johannes

