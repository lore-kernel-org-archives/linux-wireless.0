Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2JKRZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 13:25:52 -0400
Message-ID: <1349976385.13097.13.camel@jlt4.sipsolutions.net> (sfid-20121011_192556_309749_38B94A18)
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 19:26:25 +0200
In-Reply-To: <5077008D.7030203@broadcom.com>
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
	 <1349973674.13097.11.camel@jlt4.sipsolutions.net>
	 <5077008D.7030203@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 19:23 +0200, Arend van Spriel wrote:
> > Looks ok ... but why would a driver need to parse P2P stuff? For NoA for
> > example maybe?
> 
> I did not yet go through a lot of the P2P code that is on my plate to 
> port upstream, but one item that is extracted in the part I already did 
> is the P2P listen channel. I just wanted to do this RFC before sending 
> out the brcmfmac code patches that actually is using it. This change 
> will be part of that patch series.

Ah, fmac, that will be somewhat interesting. What userspace APIs are you
proposing for that case?

johannes

