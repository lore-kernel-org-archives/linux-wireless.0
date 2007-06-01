Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40931
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764485AbXFAUiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:38:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Locking problem in bcm43xx-mac80211
Date: Fri, 1 Jun 2007 22:38:14 +0200
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
References: <46605D8C.1030004@lwfinger.net>
In-Reply-To: <46605D8C.1030004@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706012238.14678.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 19:55:24 Larry Finger wrote:
> When a 'modprobe -r bcm43xx-mac80211' command is given with the interface up, the following kernel 
> BUG is issued:

Known. Ignore it for now.

I sent out a patch to Jiri to fix this, but it hasn't
been acked (yet?). Jiri thinks it introduces a race. I think
it doesn't. ;)


-- 
Greetings Michael.
