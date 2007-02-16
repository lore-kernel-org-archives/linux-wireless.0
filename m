Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:46002 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946313AbXBPXyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 18:54:19 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HICsp-0004vT-T6
	for linux-wireless@vger.kernel.org; Fri, 16 Feb 2007 18:52:55 -0500
Received: from proski by gnu.org with local (Exim 4.66)
	(envelope-from <proski@gnu.org>)
	id 1HICu9-0007Rb-UJ
	for linux-wireless@vger.kernel.org; Fri, 16 Feb 2007 18:54:17 -0500
Subject: wireless-dev.git breaks wireless extensions
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 16 Feb 2007 18:54:17 -0500
Message-Id: <1171670057.28539.5.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Today's wireless-dev.git breaks wireless extensions.  It forces
CONFIG_CFG80211 to be enabled.  I reported that it breaks legacy driver=
s
back in December 2006.  It's still broken.  That's what I get for
MadWifi:

ath0      4=BF3=C0=D8=BD=BF  ESSID:"" [51]  Nickname:""
          Channel:-0  Access Point: 9F:DD:13:94:33:C0   Bit Rate=3D-576=
733 kb/s  =20
          Tx-Power=3Doff   Sensitivity=3D-576733388 dBm =20
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=3D0/94  Signal level=3D-96 dBm  Noise level=3D-9=
6 dBm
          Rx invalid nwid:2088  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I'll appreciate if things known be broken are not enabled by default,
let alone unconditionally.

--=20
Regards,
Pavel Roskin

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
