Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3EGKVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 06:21:04 -0400
Message-ID: <1367922058.8328.2.camel@jlt4.sipsolutions.net> (sfid-20130507_122108_726434_F7BDEFEA)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 May 2013 12:20:58 +0200
In-Reply-To: <5182BBD4.9010701@broadcom.com>
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <51823A0E.8020005@broadcom.com>
	 <1367489163.8298.2.camel@jlt4.sipsolutions.net>
	 <5182BBD4.9010701@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 21:17 +0200, Arend van Spriel wrote:
> On 05/02/2013 12:06 PM, Johannes Berg wrote:
> > On Thu, 2013-05-02 at 12:03 +0200, Arend van Spriel wrote:
> >
> >> I tested the patch on x86 platform and was successful executing a
> >> p2p_find, p2p_connect, and able to ping my peer. But....
> >>
> >> When I tried this a second time I got a lockdep warning about annotation
> >> as brcmfmac tried to take a mutex during scan (p2p_find). Two minutes
> >> later I got warning about rcu stalls. Not sure where to look.
> >
> > Me neither? :) What does it say?
> 
> crap. One time I get the lockdep warning/rcu stall and the next a null 
> pointer access, but the stack trace is the same. Afraid this is a 
> brcmfmac issue that I will have to look into it.

Did you figure this out? At least whether or not it was an issue in my
patch? :)

johannes

