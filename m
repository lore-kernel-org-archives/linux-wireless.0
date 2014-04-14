Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.carbon4.de ([85.214.213.20]:47319 "EHLO
	h2156042.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaDNRyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 13:54:53 -0400
Date: Mon, 14 Apr 2014 20:00:08 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH 2/7] mac80211: add get_expected_throughput
 API
Message-ID: <20140414180008.GW26376@medion.lan> (sfid-20140414_195505_689130_F212E0A1)
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
 <1397484205-20905-2-git-send-email-antonio@meshcoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397484205-20905-2-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Antonio Quartulli <antonio@meshcoding.com> [14.04.2014 16:53]:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Add get_expected_throughput() API to mac80211 so that each
> driver can implement its own version based on the RC

Without understanding this fully: thank you.

What is not clear to me: the function returns Mbps/100.
Why not simply kilobit/second?

Also: does it return expected_goodput or "only" throughput?
Because we want to use this value not internally only it should
reflect the real usecase (and should also be human-readable).

For a meshnet it is important to know, that a 10mbit ethernet line
is faster than a 60 mbit wireless link with a low tx-probability.

bye, Bastian Bittorf
