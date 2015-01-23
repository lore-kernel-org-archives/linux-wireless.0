Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:65024 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbAWLBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:01:00 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so6886730wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 03:00:59 -0800 (PST)
Date: Fri, 23 Jan 2015 12:50:18 +0200
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vadim Kochan <vadim4j@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH mac80211-next] nl80211: Allow set network namespace by fd
Message-ID: <20150123104956.GA22514@angus-think.wlc.globallogic.com> (sfid-20150123_120104_994492_33804160)
References: <1421073245-20312-1-git-send-email-vadim4j@gmail.com>
 <1422006704.2728.15.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422006704.2728.15.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 10:51:44AM +0100, Johannes Berg wrote:
> On Mon, 2015-01-12 at 16:34 +0200, Vadim Kochan wrote:
> > From: Vadim Kochan <vadim4j@gmail.com>
> > 
> > Added new NL80211_ATTR_NETNS_FD which allows to
> > set namespace via nl80211 by fd.
> 
> Applied.
> 
> johannes
> 

Hi,

I have changes for 'iw' for setting netns by name in the same way as it
works in 'ip link set dev XXX netns <NAME>', so it uses /var/run/netns
path by default or absolute path if it sees "/" in the netns name.

So may be I will send the patch as RFC just to see a feedback ?

Thanks,
