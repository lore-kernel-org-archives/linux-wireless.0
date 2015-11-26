Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38141 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbKZRFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:05:37 -0500
Message-ID: <1448557534.2167.25.camel@sipsolutions.net> (sfid-20151126_180545_722354_36D9F628)
Subject: Re: [PATCH v3] mac80211: do not actively scan DFS channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Thu, 26 Nov 2015 18:05:34 +0100
In-Reply-To: <1448100820-22567-1-git-send-email-antonio@meshcoding.com>
References: <1448100820-22567-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-11-21 at 18:13 +0800, Antonio Quartulli wrote:
> DFS channels should not be actively scanned as we can't be sure
> if we are allowed or not.
> 
> If the current channel is in the DFS band, active scan might be
> performed after CSA, but we have no guarantee about other channels,
> therefore it is safer to prevent active scanning at all.
> 
Applied to mac80211.git, also added cc stable. I modified the code a
bit to be shorter :)

johannes
