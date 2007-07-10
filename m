Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41594
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbXGJIvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 04:51:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: Monitor mode with RTL8187
Date: Tue, 10 Jul 2007 10:50:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com> <4693176F.6070407@warmcat.com> <f6vep6$n3$1@sea.gmane.org>
In-Reply-To: <f6vep6$n3$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707101050.17043.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 July 2007 10:07:02 Stefan Schweizer wrote:
> Andy Green wrote:
> > ifconfig wlan0 down
> > 
> > Then after changing the mode, bring it up and set the channel.
> 
> why can it not do that automatically when issueing the mode monitor command?
> 
> Seems usability has not yet reached wireless configuration - where it is imo
> much needed.

ehm, setting the mode means setting the mode. Not bringing the device
up, changing channels or something like that.
The time where some wireless config commands magically trigger unrelated
events (ESSID setting triggers assoc) is over, with the advent of cfg80211.
And that is _good_.

-- 
Greetings Michael.
