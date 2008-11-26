Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:12192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYKZIT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:19:28 -0500
Received: by fg-out-1718.google.com with SMTP id 19so235328fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 00:19:26 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] ipw2200: increase scan timeout
Date: Wed, 26 Nov 2008 09:19:02 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net
References: <200811251809.55461.helmut.schaa@gmail.com> <1227641737.24264.5.camel@localhost.localdomain>
In-Reply-To: <1227641737.24264.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811260919.03118.helmut.schaa@gmail.com> (sfid-20081126_091933_357447_9AB8B173)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 25. November 2008 schrieb Dan Williams:
> On Tue, 2008-11-25 at 18:09 +0100, Helmut Schaa wrote:
> > I have no idea in which situations the scan takes longer than 5 seconds to
> > complete but maybe it might even take longer than 10 seconds. Has anybody from
> > Intel insight into the firmware scan code?
> 
> Probably because with 802.11a, you have so many more channels to scan.
> Depending on whether they are active or passive, you may be able to do
> probe-scans on them, or you may have to sit on each channel for 120ms to
> listen for beacons.  It's not unusual for cards that support A channels
> to take two or three times as long for a scan as cards that support only
> b/g, depending on the channel list.

Sure, but the strange thing is that not every scan took longer than 5 seconds.
I did not run much measurements but some scans even finished in less than 3
seconds.

Helmut
