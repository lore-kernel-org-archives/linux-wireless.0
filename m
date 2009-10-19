Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2216 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZJSIeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 04:34:17 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: libertas + cfg80211: road for kernel inclusion?
Date: Mon, 19 Oct 2009 10:33:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <200910161426.22206.hs4233@mail.mn-solutions.de> <1255709780.14241.26.camel@localhost.localdomain>
In-Reply-To: <1255709780.14241.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910191034.00045.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you can keep working on this, I'd say lets shoot for kernel
> inclusion in 2.6.34.  

I'm not sure if I can keep working on this: this week we move our 
office and I can at any time assigned to a new project. That 
said: I plan to keep working on this.


Okay, my current plan is to isolate WEXT stuff, e.g. delete what 
is already unused, move WEXT related stuff from dev.h into 
assoc.h/wext.h/scan.h (whereever it fits best), move WEXT 
related stuff in the lbs_private definition next to each other. 
Most of this won't do any functional change, but would make the 
cfg80211 patch smaller in size.


> But we'd need at least adhoc support before then.

Seems that I need to experiment with AD-HOC after all. Never used 
it before :-)

-- 
http://www.holgerschurig.de
