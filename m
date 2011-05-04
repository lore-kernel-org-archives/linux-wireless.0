Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1EDUCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 16:02:45 -0400
Subject: Re: WARNING from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DC1AF49.7080204@lwfinger.net> (sfid-20110504_215621_111957_531CD5AD)
References: <4DC1AF49.7080204@lwfinger.net>
	 (sfid-20110504_215621_111957_531CD5AD)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 22:02:43 +0200
Message-ID: <1304539363.3563.28.camel@jlt3.sipsolutions.net> (sfid-20110504_220248_567618_E68D3CE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-04 at 14:55 -0500, Larry Finger wrote:
> Johannes and John,
> 
> A regression in recent versions of mac80211 are generating the WARNING at 
> net/mac80211/wep.c:101, because the skb headroom is less than WEP_IV_LEN or the 
> tailroom is less than WEP_ICV_LEN. My testing indicates that it is a headroom 
> problem as the following hack "fixes" it:

See also this thread:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/69062/focus=69150

and the resulting patch:
http://article.gmane.org/gmane.linux.kernel.wireless.general/69190
(not sure why it was RFC?)

johannes

