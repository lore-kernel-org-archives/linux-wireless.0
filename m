Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1DEOus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 10:50:48 -0400
Subject: Re: [RFC] mac80211: Add station uptime in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D9B28D0.7020306@atheros.com>
References: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com>
	 <201104051604.16143.helmut.schaa@googlemail.com>
	 <4D9B28D0.7020306@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 16:50:45 +0200
Message-ID: <1302015045.4968.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 20:06 +0530, Mohammed Shafi wrote:
> On Tuesday 05 April 2011 07:34 PM, Helmut Schaa wrote:
> > Am Dienstag, 5. April 2011 schrieb Mohammed Shafi Shajakhan:
> >    
> >> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>
> >> Add station uptime parameter in debugfs. This will be helpful to get a
> >> measure of stability of connection and also during stress testing.
> >>      
> > It might even make sense to make this available through nl80211. At least
> > in AP mode it would be interesting to see how long each STA is already
> > connected.
> >
> > Helmut
> >    
> Thanks, will do it  once the maintainers are ok with this patch.

Fine with me, but you should probably not call it "uptime" but rather
"connected_time" or something, and address Felix's point.

johannes

