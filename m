Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2LTLjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:39:45 -0500
Message-ID: <1356003605.10029.9.camel@jlt4.sipsolutions.net> (sfid-20121220_123949_001764_538E1AE2)
Subject: Re: Re: adding ba_policy member in drv_ampdu_action op - request
 information
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 12:40:05 +0100
In-Reply-To: <ccd9b999d335370ce1508dae369e0951@posedge.com>
References: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com>
	 <1355407319.9463.4.camel@jlt4.sipsolutions.net>
	 <ccd9b999d335370ce1508dae369e0951@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 02:39 -0800, vivekanandah@posedge.com wrote:

> is'nt the station's capability and the AP capability intersected during 
> association? i always thought that the comment was mis-represented.
> 
> i did a small test and i see that the stations capability is actually 
> the subset of AP capabilities that both support.
> if that is the case, then we do not have to check for the capability 
> independently there! do i miss something in my understanding?
> 
> also, if what i have stated above is correct, then yes, i feel delayed 
> block ack as a feature might need to be implemented on mac80211 and then 
> check for the same.

I don't see what difference that makes? You still have to implement the
feature fully, we don't have support for it at all.

johannes

