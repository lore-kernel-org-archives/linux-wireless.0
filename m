Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33860 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZFFRtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:49:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
Date: Sat, 6 Jun 2009 19:49:06 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de> <1244310138.17485.11.camel@johannes.local>
In-Reply-To: <1244310138.17485.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906061949.06735.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 June 2009 19:42:18 Johannes Berg wrote:
> On Fri, 2009-06-05 at 21:01 +0200, Michael Buesch wrote:
> 
> > >      The rfkill polling routine brings the interface back to the initialized
> > >      state if it is found to be uninitialized. This way the rfkill switch
> > >      may be interpreted. In addition, the radio LED is not turned on in the
> > >      initialization routine unless the rfkill switch is on.
> > 
> > This is pretty silly behavior IMO. Just to bring it to the point:
> > We initialize a huge wireless MAC, PHY and Radio that consume several watts of power
> > just to poll a silly RF-kill bit.
> 
> 1) you're MUCH overstating the power consumption

Care to measure it?

> Fine. Just don't stand in my way then.

I am not standing in your way. I'm just not going to maintain it.
In fact, I'd like to pass the whole maintainership to somebody else. But I guess there is nobody.

-- 
Greetings, Michael.
