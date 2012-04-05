Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DENBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 09:01:24 -0400
Message-ID: <1333630881.3494.15.camel@jlt3.sipsolutions.net> (sfid-20120405_150136_924671_F1E2D32D)
Subject: Re: compat-wireless-2012-04-04 - rmmod mac80211 and PC freeze
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Apr 2012 15:01:21 +0200
In-Reply-To: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com> (sfid-20120405_143524_201944_133524A9)
References: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com>
	 (sfid-20120405_143524_201944_133524A9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-05 at 14:35 +0200, Janusz Dziedzic wrote:
> Hello,
> 
> I am using: compat-wireless-2012-04-04
> 
> I am doing such test:
> - insmod compat.ko
> - insmod cfg80211.ko
> - insmod mac80211.ko
> 
> After that:
> - rmmod mac80211
> 
> And have PC freeze.
> Linux uw000950 2.6.35-32-generic #67~lucid1-Ubuntu SMP Tue Mar 6
> 17:48:20 UTC 2012 x86_64 GNU/Linux

Works for me, but on 3.1.0.

> Any idea what could be wrong, how to debug in case of such freeze?

Not really. You could try the same thing from a console, rather than an
X terminal window (that I'm guessing you're using since you saw no
further info) and you may see some more details?

johannes

