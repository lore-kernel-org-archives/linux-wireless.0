Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55710 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbZKINJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 08:09:39 -0500
Subject: Re: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Sack <asac@ubuntu.com>, Dan Williams <dcbw@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
In-Reply-To: <1257771261.29454.169.camel@johannes.local>
References: <1256953837.9681.13.camel@maxim-laptop>
	 <1257190833.1027.4.camel@localhost.localdomain>
	 <20091109125016.GK1579@jwsdot.com>
	 <1257771261.29454.169.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 14:09:34 +0100
Message-ID: <1257772174.3024.11.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Soon.  We've got some patches for this, but we'll also need tons of
> > > testing.  The WEXT stuff is pretty baked while nl80211 is still under
> > > some flux.  But of course the only way we bake nl80211 is by switching
> > > to it...
> > 
> > iirc, we currently we hardcode wext in NM code. How about adding a keyfile
> > config that users could use to switch to nl80211 until we feel confident
> > that it's good enough for everyone?
> 
> commit d27df100b587dd95f3256a8baf9db0c5d4380089 in wpa_supplicant allows
> you to do that by editing the service file.

that is funny, when I asked for a global command line switch for
choosing a different driver, the argument was that the application
adding the interface is suppose to do it by itself. Now we can do it in
the service file. Never the less ConnMan got its own switch to choose
which driver will be used. Does help a lot in testing and is way easier
since you don't have to restart wpa_supplicant all the time.

Regards

Marcel


