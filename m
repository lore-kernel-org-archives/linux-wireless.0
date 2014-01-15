Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAONZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:25:56 -0500
Message-ID: <1389792352.4338.10.camel@jlt4.sipsolutions.net> (sfid-20140115_142558_899122_6B92CC25)
Subject: Re: [RFC 5/5] cfg80211: setup CAC time in db.txt for PL
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 15 Jan 2014 14:25:52 +0100
In-Reply-To: <1389720570-2430-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182950_657506_03BCBD9F)
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389720570-2430-6-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140114_182950_657506_03BCBD9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 18:29 +0100, Janusz Dziedzic wrote:
> This is DFS CAC time setup for PL.
> We should do the same for all other
> countries that support DFS in wireless-regd.
> Here only as example, please don't merge.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  net/wireless/db.txt |    6 ++++--

That file doesn't exist in the kernel tree anyway ...

johannes

