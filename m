Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAPKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 10:10:02 -0500
Message-ID: <1362150589.24973.0.camel@jlt4.sipsolutions.net> (sfid-20130301_161007_458778_D9196D98)
Subject: Re: [PATCH] mac80211: fix oops on mesh PS broadcast forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 01 Mar 2013 16:09:49 +0100
In-Reply-To: <1362150078-10802-1-git-send-email-marco@cozybit.com> (sfid-20130301_160127_662995_0DE5B588)
References: <1362150078-10802-1-git-send-email-marco@cozybit.com>
	 (sfid-20130301_160127_662995_0DE5B588)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 16:01 +0100, Marco Porsch wrote:
> Introduced with de74a1d9032f4d37ea453ad2a647e1aff4cd2591
> "mac80211: fix WPA with VLAN on AP side with ps-sta".
> Apparently overwrites the sdata pointer with non-valid data in
> the case of mesh.
> Fix this by checking for IFTYPE_AP_VLAN.

Applied.

johannes

