Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35782 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbbAWLHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:07:03 -0500
Message-ID: <1422011219.2728.32.camel@sipsolutions.net> (sfid-20150123_120708_099208_1369F752)
Subject: Re: [PATCH mac80211-next] nl80211: Allow set network namespace by fd
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 12:06:59 +0100
In-Reply-To: <20150123104956.GA22514@angus-think.wlc.globallogic.com> (sfid-20150123_120059_664142_EF56EEC4)
References: <1421073245-20312-1-git-send-email-vadim4j@gmail.com>
	 <1422006704.2728.15.camel@sipsolutions.net>
	 <20150123104956.GA22514@angus-think.wlc.globallogic.com>
	 (sfid-20150123_120059_664142_EF56EEC4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 12:50 +0200, Vadim Kochan wrote:

> I have changes for 'iw' for setting netns by name in the same way as it
> works in 'ip link set dev XXX netns <NAME>', so it uses /var/run/netns
> path by default or absolute path if it sees "/" in the netns name.
> 
> So may be I will send the patch as RFC just to see a feedback ?

Sure, sounds good.

johannes

