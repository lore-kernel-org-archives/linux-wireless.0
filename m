Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53765 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbcDEKTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 06:19:35 -0400
Message-ID: <1459851570.18188.45.camel@sipsolutions.net> (sfid-20160405_121938_011798_D7FDA0E0)
Subject: Re: [PATCH v2] mac80211: mesh: fix crash in mesh_path_timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 12:19:30 +0200
In-Reply-To: <1458353004-8062-1-git-send-email-me@bobcopeland.com> (sfid-20160319_030332_405389_1AF16D7E)
References: <1458353004-8062-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160319_030332_405389_1AF16D7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 22:03 -0400, Bob Copeland wrote:
> The mesh_path_reclaim() function, called from an rcu callback,
> cancels
> the mesh_path_timer associated with a mesh path.  Unfortunately, this
> call can happen much later, perhaps after the hash table itself is
> destroyed.
> 
[...]

applied.

johannes
