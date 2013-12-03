Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3LCMy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:54:29 -0500
Message-ID: <1386075265.4393.12.camel@jlt4.sipsolutions.net> (sfid-20131203_135432_683018_EA6E3839)
Subject: Re: [PATCH v3 1/4] cfg80211: add reg_get_dfs_region()
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 03 Dec 2013 13:54:25 +0100
In-Reply-To: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131125_205622_297162_1B2C7FC5)
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131125_205622_297162_1B2C7FC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 20:56 +0100, Janusz Dziedzic wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> This can be used outside of the regulatory context for any checks
> on the DFS region. The central cfg80211 dfs_region is always used
> and if it does not match with the wiphy a debug print is issued.

Ok I've applied patches 1 and 2

johannes

