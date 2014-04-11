Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaDKIAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 04:00:38 -0400
Message-ID: <1397203220.4420.7.camel@jlt4.sipsolutions.net> (sfid-20140411_100041_456798_326B79C3)
Subject: Re: [PATCH] cfg80211: reg: set DFS CAC time in case of custom regd
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Apr 2014 10:00:20 +0200
In-Reply-To: <1397044032-2723-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140409_134736_078810_42F4AA17)
References: <1397044032-2723-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140409_134736_078810_42F4AA17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 13:47 +0200, Janusz Dziedzic wrote:
> Set DFS CAC time also in case of using custom
> and strict regulatory from drivers. In other case
> we could have unset DFS CAC time directly after
> driver loaded and before issue regulatory set from
> user mode.

Applied.

johannes

