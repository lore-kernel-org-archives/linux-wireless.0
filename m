Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbaDIMub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:50:31 -0400
Message-ID: <1397047812.4964.17.camel@jlt4.sipsolutions.net> (sfid-20140409_145044_544764_27871522)
Subject: Re: [PATCH 4/8] mac80211: fix possible compile warning in
 debugfs_netdev.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 14:50:12 +0200
In-Reply-To: <9709360a8341770ec487d9033bfa17fdebbb4bf0.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032857_989434_022A51D3)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 <9709360a8341770ec487d9033bfa17fdebbb4bf0.1397006688.git.gamerh2o@gmail.com>
	 (sfid-20140409_032857_989434_022A51D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 09:28 +0800, Zhao, Gang wrote:
> The warning doesn't show up due to duplicate including, but it's worth
> fixing it.

I've applied patches 2-4 as a single squashed patch. I'm definitely
dropping 5-8, and still considering patch 1.

johannes

