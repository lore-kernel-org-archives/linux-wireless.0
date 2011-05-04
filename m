Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1EDUPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 16:15:37 -0400
Subject: Re: WARNING from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DC1B2F3.3070300@lwfinger.net> (sfid-20110504_221159_139416_1F7955D3)
References: <4DC1AF49.7080204@lwfinger.net>
	 (sfid-20110504_215621_111957_531CD5AD) <1304539363.3563.28.camel@jlt3.sipsolutions.net>
	 <4DC1B2F3.3070300@lwfinger.net> (sfid-20110504_221159_139416_1F7955D3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 22:15:37 +0200
Message-ID: <1304540137.3563.30.camel@jlt3.sipsolutions.net> (sfid-20110504_221540_055230_27C286BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-04 at 15:11 -0500, Larry Finger wrote:

> > See also this thread:
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/69062/focus=69150
> >
> > and the resulting patch:
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/69190
> > (not sure why it was RFC?)
> 
> Thanks. I do remember the thread now that you refreshed my memory. That patch 
> does fix my problem.

Good to know. John should probably merge that patch even though it was
RFC.

johannes

