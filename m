Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaBUIyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:54:54 -0500
Message-ID: <1392972891.4346.39.camel@jlt4.sipsolutions.net> (sfid-20140221_095456_629206_2C8BC6A1)
Subject: Re: [PATCH 4/4] cfg80211: DFS get CAC time from regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Fri, 21 Feb 2014 09:54:51 +0100
In-Reply-To: <1392231266-28479-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195441_189422_FB19079E)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1392231266-28479-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140212_195441_189422_FB19079E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:

> +	if (t2 > t1)
> +		t1 = t2;
> +
> +	return t1;

return max(t1, t2);

Is there any real reason to split patches 3/4? It seems to me they
should go together.

johannes

