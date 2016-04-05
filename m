Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53669 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbcDEKAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 06:00:03 -0400
Message-ID: <1459850399.18188.39.camel@sipsolutions.net> (sfid-20160405_120008_910952_0A9D252E)
Subject: Re: [PATCH] mac80211: Remove unused variable in per STA debugfs
 struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: mohammed@codeaurora.org
Date: Tue, 05 Apr 2016 11:59:59 +0200
In-Reply-To: <1458397784-15279-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1458397784-15279-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-03-19 at 19:59 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Remove unused variable in per STA debugfs structure, 'commit
> 34e895075e21
> ("mac80211: allow station add/remove to sleep")' removed the only
> user of
> 'add_has_run'.
> 
Applied.

johannes
