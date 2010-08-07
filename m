Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34118 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab0HGSqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 14:46:00 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id E6E531819F6
	for <linux-wireless@vger.kernel.org>; Sat,  7 Aug 2010 14:45:54 -0400 (EDT)
Message-Id: <1281206754.31161.1388795015@webmail.messagingengine.com>
From: "giovanni_re" <john_re@fastmail.us>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Wifi GNOME network manager version into KUbuntu, Debian "pinning
 method, etc. ; jor linux-wireless-kernel
Date: Sat, 07 Aug 2010 11:45:54 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

KUbuntu 10.4,

=
Failing to get wifi to connect to access point.  It can see APs, but
fails to get dhcp via command mode, & fails connect with wicd.

=
It has been suggested (on KUbuntu list?) to remove the KU network
manager package, & that might get wicd & console command wifi working.

Previously, I was told that there is more networking success if one
installs Ubuntu (not KUbuntu) [to get the Ubuntu/Gnome network manager
sw], then install KDE on top of that.

=
For a system that was installed as KUbuntu:

Might it be possible to use something like Debian "pinning" to hold back
the KU network manager package, & then install the Ubuntu NetworkManager
package?  Guess I'd at least have to ad the Ubuntu repositories to
/etc/apt/sources.list.

There might also be another debian method to do this.

=
 Being as Ubuntu is Debian based, is there some way to make this work?

=
I ran Debian from about 2000-2005, so haven't done pinning for a long
time.

=
Thanks :)

==  Join in the Global weekly meetings, via VOIP, about all Free SW HW & Culture
http://sites.google.com/site/berkeleytip/

