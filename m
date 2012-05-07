Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2EGHAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 03:00:32 -0400
Message-ID: <1336374030.4325.2.camel@jlt3.sipsolutions.net> (sfid-20120507_090037_204415_54FEF07C)
Subject: Re: carl9170 - monitor mode TP drop
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 09:00:30 +0200
In-Reply-To: <201205032344.17313.chunkeey@googlemail.com> (sfid-20120503_234452_333071_DDB27FCC)
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
	 <201204251928.21559.chunkeey@googlemail.com>
	 <1336031908.3459.4.camel@jlt3.sipsolutions.net>
	 <201205032344.17313.chunkeey@googlemail.com>
	 (sfid-20120503_234452_333071_DDB27FCC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 23:44 +0200, Christian Lamparter wrote:

> > > You see without the BIT set, the hardware won't sent any ACKs
> > > (Not even those which are directed at this interface - which of
> > > course is also bad, or even worse?) and with the BIT set (and if
> > > the HW is in Sniffer Mode) then the hardware acks every frames,
> > > even if they are for a different stations.
> > > So your fix might break someone else's setup.
> > 
> > You may want to implement the new monitor-mode-vif-to-driver thing in
> > mac80211 which tells you when you're in *pure* monitor mode.
> 
> "the new monitor-mode-vif-to-driver"?
> Do you mean like adding a new IFTYPE flag? Or more like a FIF_* flag
> (probably)? for the "pure" monitor/sniffer mode?

No, see 4b6f1dd6a6faf4ed8d209bbd548e78b15e55aee8

johannes

