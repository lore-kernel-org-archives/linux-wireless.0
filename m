Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58390 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766722AbXDSOet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 10:34:49 -0400
Date: Thu, 19 Apr 2007 16:34:53 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
Message-ID: <20070419163453.5d792085@griffin.suse.cz>
In-Reply-To: <46211955.4080006@lwfinger.net>
References: <46211955.4080006@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 14 Apr 2007 13:11:33 -0500, Larry Finger wrote:
> In wireless statistics reporting, three quantities related to the
> signal are reported: "qual" (linear with the signal),
> "level" (logarithmic), and "noise". In mac80211 and the drivers that
> use it, the first two have a mixture of internal names for those
> quantities.

The whole signal reporting in WE looks like a mess to me. It seems that
no renaming could help here, I'm afraid - the names you consider better
others consider worse.

Let's leave it as is, and return to it when converting mac80211 to use
cfg80211. With a bit of luck it would be no issue then :-)

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
