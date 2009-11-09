Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbZKIMuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:50:05 -0500
Date: Mon, 9 Nov 2009 13:50:16 +0100
From: Alexander Sack <asac@ubuntu.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
Subject: Re: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
Message-ID: <20091109125016.GK1579@jwsdot.com>
References: <1256953837.9681.13.camel@maxim-laptop>
 <1257190833.1027.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257190833.1027.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2009 at 11:40:33AM -0800, Dan Williams wrote:
> On Sat, 2009-10-31 at 03:50 +0200, Maxim Levitsky wrote:
> > Sorry for cross-posting, but this issue really spans all three systems.
> > 
> > I anylized why I get 100% quality on all access points except currently
> > connected, when I used driver_nl80211 of wpa_supplcant.
> > 
> > First, when NetworkManager plans to switch to this driver?
> 
> Soon.  We've got some patches for this, but we'll also need tons of
> testing.  The WEXT stuff is pretty baked while nl80211 is still under
> some flux.  But of course the only way we bake nl80211 is by switching
> to it...

iirc, we currently we hardcode wext in NM code. How about adding a keyfile
config that users could use to switch to nl80211 until we feel confident
that it's good enough for everyone?

 - Alexander

