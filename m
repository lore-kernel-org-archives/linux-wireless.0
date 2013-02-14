Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839Ab3BNLFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:05:54 -0500
Message-ID: <1360839938.8210.0.camel@jlt4.sipsolutions.net> (sfid-20130214_120557_681359_E5D63669)
Subject: Re: [PATCH v2] mac80211: fix auth/assoc timeout handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 12:05:38 +0100
In-Reply-To: <511CC175.9080702@neratec.com>
References: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net>
	 <511CC175.9080702@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 11:50 +0100, Wojciech Dubowik wrote:
> I am getting some disconnections becasue of failed
> nullfunc in my ath9k ap+sta test setup. The auth/assoc
> don't timeout but nullfunc does.
> 
> I have checked in wireshark and all nullfunc were
> properly acknowledged.
> Attached syslog + iw event.
> 
> Do you have any idea where it comes from or should
> I start looking at it?

No idea right now, off the top of my head, sorry.

johannes

