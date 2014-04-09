Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaDIMrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:47:08 -0400
Message-ID: <1397047610.4964.14.camel@jlt4.sipsolutions.net> (sfid-20140409_144712_769442_FDF00559)
Subject: Re: [PATCH 1/8] cfg80211: fix possible compile warning in
 wext-compat.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 14:46:50 +0200
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032851_199422_DE76A6CA)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 (sfid-20140409_032851_199422_DE76A6CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 09:28 +0800, Zhao, Gang wrote:
> Function cfg80211_wext_freq() is declared in wext-compat.h, but its
> parameter struct wiphy's declaration is not included there. Actually
> the parameter is not used in this function, so change it to normal
> net_device.
> 
> The compile warning doesn't show up due to duplicate including, but
> it's worth fixing it.

Why not just include the right file here?

johannes

