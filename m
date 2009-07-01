Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:44959 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbZGAU5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 16:57:24 -0400
Subject: Re: Compiling wpa_supplicant?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246473271.8154.5.camel@johannes.local>
References: <1246467053.11632.13.camel@jdl-desktop>
	 <1246473271.8154.5.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:57:28 -0500
Message-Id: <1246481848.11632.33.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 20:34 +0200, Johannes Berg wrote:
> On Wed, 2009-07-01 at 11:50 -0500, Jon Loeliger wrote:
> 
> > Is there a version of hostapd/wpa_suppliant that is more
> > up-to-date WRT libnl-2.0?  Or should I just use the wext
> > driver for now?
> 
> I would suggest you compile against a released version of libnl, namely
> 1.1 :)

I was afraid someone would say something like that... :-)
And since that seems to be effort in the wrong direction,
I was even more afraid someone would say something like:

> Otherwise, you can rip the compat code out off iw and stick it
> into wpa_supplicant/hostapd.

So I did something like that.  Patch to follow.

> johannes

Thanks,
jdl


