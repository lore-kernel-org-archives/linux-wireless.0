Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60971 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377AbcBBPBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:01:30 -0500
Message-ID: <1454425288.2926.4.camel@sipsolutions.net> (sfid-20160202_160133_832167_415525DF)
Subject: Re: [PATCH v2] mac80211: mesh: drop constant field mean_chain_len
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Date: Tue, 02 Feb 2016 16:01:28 +0100
In-Reply-To: <1454177823-24313-1-git-send-email-me@bobcopeland.com> (sfid-20160130_191747_746054_94BD0458)
References: <1454177823-24313-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160130_191747_746054_94BD0458)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-01-30 at 13:17 -0500, Bob Copeland wrote:
> The mean_chain_len field in struct mesh_table is copied whenever a
> new mesh table is allocated, but only ever has the value 2 and is
> never otherwise updated, so just remove it and use the related
> define instead.
> 
Applied, thanks.

johannes
