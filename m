Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JNOSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 10:18:05 -0400
Message-ID: <1381760281.13092.14.camel@jlt4.sipsolutions.net> (sfid-20131014_161809_487564_86BD912F)
Subject: Re: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh
 beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Mon, 14 Oct 2013 16:18:01 +0200
In-Reply-To: <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203007_916657_AD660D4F)
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131011_203007_916657_AD660D4F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 11:29 -0700, Chun-Yeow Yeoh wrote:
> Support the adding of CSA and MCSP elements while building the beacon
> for mesh if necessary. This is defined in the IEEE Std 802.11-2012
> section 10.9.8.4.3 that both CSA and MCSP elements must be included
> in beacon and probe response frames until the intended channel
> switch time.

I also get

net/mac80211/mesh.c:673:42: warning: symbol 'ifmsh' shadows an earlier
one
net/mac80211/mesh.c:606:29: originally declared here


with this patch

