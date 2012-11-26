Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2KZJLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 04:11:35 -0500
Message-ID: <1353921122.9488.1.camel@jlt4.sipsolutions.net> (sfid-20121126_101314_683798_1E1F9320)
Subject: Re: RFC[2/4] mac80211: add statistic to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 10:12:02 +0100
In-Reply-To: <50B2FB62.2080808@posedge.com>
References: <50B2FB62.2080808@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 10:47 +0530, Saravana wrote:
> Provide additional statistic support to the debugfs.
> 
> Rssi of the Last Ack Frame
>          This information is available as part of ieee80211_tx_info 
> status structure. Thought this information may be useful(in future).
> 
> Signed-off-by: Saravana <saravanad@posedge.com>

Your changelog entries all need work. Additionally, please check coding
style and send patches without line wrapping please, I can't apply them
otherwise.

johannes

