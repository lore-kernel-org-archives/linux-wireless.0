Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab0E1LYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 07:24:07 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: Johannes Berg <johannes@sipsolutions.net>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BFFA490.90600@digadd.de>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>
	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>
	 <4BFF9FC6.4030101@digadd.de>
	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 13:24:03 +0200
Message-ID: <1275045843.3909.92.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 13:10 +0200, Christian P. Schmidt wrote:

> > Those values make no sense to me .. can you use "iw scan" and tell us
> > the dBm value?
> 
> This translates to -52 to -30dBm.

Ok that sounds like you have antennas.

> Well, maybe you can answer me a question I never dared to ask because I
> felt stupid... I can't take the Intel card online with only ifconfig or
> ip? I always get "unknown error 132" on ifconfig wlan0 up / ip link set
> wlan0 up...

Huh. This means that the device detected rfkill. But you previously
posted logs that showed it trying to associate, which cannot happen. And
you can't even scan when you can't bring the device up??

Maybe try the rfkill tool:
http://wireless.kernel.org/en/users/Documentation/rfkill

johannes

