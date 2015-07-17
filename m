Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbbGQMig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 08:38:36 -0400
Message-ID: <1437136714.1933.11.camel@sipsolutions.net> (sfid-20150717_143838_987373_C24FE0A2)
Subject: Re: [PATCH v3 1/5] mac80211: correct aid location in peering frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 17 Jul 2015 14:38:34 +0200
In-Reply-To: <1436877119-17577-2-git-send-email-me@bobcopeland.com> (sfid-20150714_143217_907124_B20035E5)
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
	 <1436877119-17577-2-git-send-email-me@bobcopeland.com>
	 (sfid-20150714_143217_907124_B20035E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-07-14 at 08:31 -0400, Bob Copeland wrote:
> According to 802.11-2012 8.5.16.3.2 AID comes directly after the
> capability bytes in mesh peering confirm frames.  The existing
> code, however, was adding a 2 byte offset to this location,
> resulting in garbage data going out over the air.  Remove the
> offset to fix it.
> 
applied (to mac80211.git)

johannes
