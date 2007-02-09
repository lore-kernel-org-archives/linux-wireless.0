Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60569
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946134AbXBIF6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 00:58:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH #2] d80211: Add API to generate RTS and CTS-to-self frames
Date: Fri, 9 Feb 2007 06:57:42 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkmaline@cc.hut.fi>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200702051726.09556.mb@bu3sch.de> <20070208204447.74fbd37a@griffin.suse.cz>
In-Reply-To: <20070208204447.74fbd37a@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702090657.43682.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 February 2007 20:44, Jiri Benc wrote:
> On Mon, 5 Feb 2007 17:26:09 +0100, Michael Buesch wrote:
> > This adds API calls to generate RTS and CTS-to-self frames.
> > To be called if the device firmware requires the host to
> > generate RTS/CTS frames.
> 
> Applied to my tree, thanks for the patch.

Did you also apply rt2x00 and bcm43xx followup patches?
Please note that rt2x00 is broken, if you apply this API change and leave the
rt2x00 RTS fix out.

You don't necessarily need to apply that bcm43xx RTS patch. I can do it, too.
In fact, it needs another bugfix to not crash. :) I think I already sent that fix to John.
