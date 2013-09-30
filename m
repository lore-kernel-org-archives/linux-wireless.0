Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3I3ObM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:31:12 -0400
Message-ID: <1380551468.14467.16.camel@jlt4.sipsolutions.net> (sfid-20130930_163114_820138_5C10613F)
Subject: Re: [PATCH] cfg80211: parse dfs region for internal regdb option
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, mcgrof@do-not-panic.com
Date: Mon, 30 Sep 2013 16:31:08 +0200
In-Reply-To: <1379399136-3181-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130917_082645_746795_B2BB7D43)
References: <1379399136-3181-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20130917_082645_746795_B2BB7D43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 08:25 +0200, Janusz Dziedzic wrote:
> Add support for parsing and setting the dfs region (ETSI, FCC, JP)
> when the internal regulatory database is used. Before this
> the DFS region was being ignored even if present on the used
> db.txt

Looks good to me, Luis?

johannes

