Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:55851 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946Ab0GTXIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 19:08:01 -0400
Subject: Re: [RFC] cfg80211: fix race between sysfs and cfg80211
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1279394982.3931.0.camel@jlt3.sipsolutions.net>
References: <1279336415.1941.6.camel@kero>
	 <1279394982.3931.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 21 Jul 2010 01:07:52 +0200
Message-ID: <1279667272.32146.21.camel@sakura.staff.proxad.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2010-07-17 at 21:29 +0200, Johannes Berg wrote:

Hi Johannes,

> Maybe we should hold the mutex around the debugfs stuff as well? Then
> tools could even access that race-free, and we can simplify the code by
> having an "out_unlock" label.

Any comment on the last patch I sent ?

Thanks !

-- 
Maxime


