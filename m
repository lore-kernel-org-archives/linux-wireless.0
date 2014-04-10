Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaDJRMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 13:12:51 -0400
Message-ID: <1397149960.4757.22.camel@jlt4.sipsolutions.net> (sfid-20140410_191300_662003_F18CED90)
Subject: Re: [RFCv2 6/6] cfg80211: implement cfg80211_get_station cfg80211
 API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Thu, 10 Apr 2014 19:12:40 +0200
In-Reply-To: <5346C0B3.4050704@open-mesh.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
		 <1396211704-4677-7-git-send-email-antonio@meshcoding.com>
	 <1396951582.5936.20.camel@jlt4.sipsolutions.net>
	 <5346C0B3.4050704@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 18:02 +0200, Antonio Quartulli wrote:

> > Any thoughts about clearing/filling/partially filling *sinfo when
> > returning an error?
> 
> At the moment this function relies on what rdev_get_station() does and I
> always assumed that in case of error the content of *sinfo should be
> considered "undefined".

That's fine, maybe add a line of documentation?

johannes

