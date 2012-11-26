Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2KZLro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:47:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TcxA7-0001aH-F1
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 12:47:43 +0100
Message-ID: <1353930491.9488.31.camel@jlt4.sipsolutions.net> (sfid-20121126_124747_955754_77B75A1B)
Subject: Re: [PATCH] cfg80211: fix some tracing output issues
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 12:48:11 +0100
In-Reply-To: <1353099631-14398-1-git-send-email-johannes@sipsolutions.net> (sfid-20121116_220003_358864_80D15B27)
References: <1353099631-14398-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121116_220003_358864_80D15B27)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:00 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some cases, e.g. probe_status, there were spaces
> missing so the trace output was confusing. Also make
> it more like mac80211 when printing netdevs/wiphys
> to make reading a combined log easier.

Applied.

johannes

