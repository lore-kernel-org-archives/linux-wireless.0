Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KENVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:21:19 -0500
Message-ID: <1383657674.4444.6.camel@jlt4.sipsolutions.net> (sfid-20131105_142122_939015_34E4C268)
Subject: Re: [PATCH v3 2/3] mac80211_hwsim: Add iface comb for DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Nov 2013 14:21:14 +0100
In-Reply-To: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_130421_274324_24F26AE7)
References: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_130421_274324_24F26AE7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 13:03 +0100, Janusz Dziedzic wrote:
> Add iface combination that will allow DFS
> support. Add also debugfs dfs_simulate_radar
> file that can be used to simulate radar event.
> This could be useful for mac80211/cfg80211/
> regulatory/hostap code testing without real HW.

Ok this seems to run through with channels=2, applied.

However, I think we need to revisit this - it'd be useful to have one
device with channels=2 and another with DFS, for example.

I think Marcel has patches for this though, to allow creating devices
dynamically at runtime.

johannes

