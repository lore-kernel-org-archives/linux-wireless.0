Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46499 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbZLHUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 15:15:12 -0500
Date: Tue, 8 Dec 2009 15:05:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: wireless device and udev
Message-ID: <20091208200504.GC16303@tuxdriver.com>
References: <20091207172616.7470ed2b@nehalam> <20091208142940.GB15172@tuxdriver.com> <20091208104336.3d5a7fb4@nehalam> <20091208185222.GA16303@tuxdriver.com> <1260300551.32227.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1260300551.32227.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 08, 2009 at 08:29:11PM +0100, Johannes Berg wrote:
> On Tue, 2009-12-08 at 13:52 -0500, John W. Linville wrote:
> 
> > So, probably we need to map from the wlanX name to the phyY name,
> > then determine whether or not this is the first wlanX for phyY.
> > If not, then the name should be left alone.
> > 
> > Now, how do we figure out how many wlanX's belong to phyY?
> 
> And what's the "first" one? :)

I suppose I was figuring that if there was only one, it was the
first. :-)  But you're right, I suppose that could be racy...

> ls /sys/class/net/wlan0/device/net/
> 
> will give you the list of interface associated with this device.

Cool...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
