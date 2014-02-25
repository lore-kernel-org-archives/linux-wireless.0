Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaBYQdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:33:15 -0500
Message-ID: <1393345990.4170.20.camel@jlt4.sipsolutions.net> (sfid-20140225_173318_815837_F6AC99A1)
Subject: Re: [PATCH v2 2/2] cfg80211: DFS get CAC time from regulatory
 database
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Tue, 25 Feb 2014 17:33:10 +0100
In-Reply-To: <1393008373-4069-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140221_194626_685715_8F19B8F6)
References: <1393008373-4069-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1393008373-4069-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140221_194626_685715_8F19B8F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 19:46 +0100, Janusz Dziedzic wrote:
> Send Channel Availability Check time as a parameter
> of start_radar_detection() callback.
> Get CAC time from regulatory database.

Applied both.

johannes

