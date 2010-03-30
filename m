Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:11968 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0C3NOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 09:14:48 -0400
Received: by qw-out-2122.google.com with SMTP id 8so3718260qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 06:14:47 -0700 (PDT)
Message-ID: <4bb1f940.47c2f10a.3469.609b@mx.google.com>
Date: Tue, 30 Mar 2010 06:14:40 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Another AR5008 hang
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1269928986.3927.5.camel@jlt3.sipsolutions.net>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Mar 2010 08:03:06 +0200, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-03-29 at 10:26 -0700, Ben Gamari wrote:
> > New (2.6.33 and greater) kernels seem to result in a selective hang on my
> > machine directly only seconds after association with an 802.11N access point
> > (hosted with hostapd and another ar5008). I've included dmesg output for a
> > failure event, including back traces of hung processes. What ath9k.debug flags
> > would be most helpful for tracing this further?
> 
> None, I would think, this seems to be a lockup between
> modprobe/stop_machine and some rtnl things, but I have no idea why that
> would happen. Do you have lockdep enabled? And if you do, please disable
> RCU lockdep as it typically gives you a warning and then turns off
> lockdep...
> 
Thank you very much for your response. I do not currently have lockdep enabled,
but I'm building a new kernel as we speak. Thanks again,

- Ben
