Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1JKT53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 15:57:29 -0400
Subject: Re: [PATCH] iw: add DFS region parsing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_200236_974718_4C26AE14)
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111011_200236_974718_4C26AE14)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 21:57:22 +0200
Message-ID: <1318363042.15357.0.camel@jlt3.sipsolutions.net> (sfid-20111011_215736_293115_C5730D9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 10:59 -0700, Luis R. Rodriguez wrote:

> +	default:
> +		printf("Uknown");

typo. Also, I prefer patches w/o nl80211.h updates.

johannes

