Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbZK1VVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:21:09 -0500
Date: Sat, 28 Nov 2009 16:21:03 -0500
From: "John W. Linville" <linville@redhat.com>
To: linux-wireless@vger.kernel.org, centos@centos.org,
	ath9k-devel@atheros.com, ipw3945@lists.sourceforge.net
Subject: RHEL5.5 (and Centos 5.5!) wireless updates needs broad testing...
Message-ID: <20091128212102.GB28915@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

RHEL5.5 is scheduled for a broad update of wireless LAN bits.
This includes updates to the cfg80211 and the mac80211 subsystems,
and the ath5k, iwl3945, iwl4965, iwl5000, rt2400pci, rt2500pci,
rt2500usb, rt61pci, rt73usb, rtl8180, and rtl8187 drivers, as well as
the addition of the iwl1000, and iwl6000 drivers and the core of the
rfkill subsystem.  For good measure, ath9k _may_ be added as well.
This represents a very large mass of code, and any extra testing is
most welcome.

Preliminary RHEL5 kernels with these wireless bits are available here:

	http://people.redhat.com/linville/kernels/rhel5/

I have been using them with iwl4965, iwl5000, iwl6000, and ath9k
hardware here with very satisfactory results.  I would appreciate
your help testing not only on this hardware but whatever other bits
of the aforementioned hardware that you may have.

If you have a wireless LAN enabled box running RHEL5 (or CentOS 5 or
other equivalent) then please give these kernels a try.  When you find
problems, please open a bug against RHEL5.5 at bugzilla.redhat.com
and Cc: me on the bug.	Remember, the surest way to avoid a bug in
RHEL5.5 is to find it before it is released, and the surest way to
avoid a bug in CentOS is to keep it out of RHEL... :-)

I appreciate your help!

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@redhat.com			of your literate lifestyle.
