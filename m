Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53019 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbYGKVTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 17:19:01 -0400
Received: from [192.168.0.21] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 6FECB4F1869
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2008 17:19:00 -0400 (EDT)
Subject: rt2x00 is still experimental?
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jul 2008 17:18:59 -0400
Message-Id: <1215811139.30975.10.camel@dv> (sfid-20080711_231928_487776_F8477FE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Can we please have rt2x00 drivers considered stable in Linux 2.6.27?  My
experience running rt73 day by day with WPA on a very crowded network
shows that it's a pretty reliable driver already.

I realize that distros would enable whatever they want, and most people
here have CONFIG_EXPERIMENTAL on anyway, but still, it could help direct
users towards better supported hardware and make CONFIG_EXPERIMENTAL
more relevant.

The latest commits to the drivers/net/wireless/rt2x00 directory seem to
confirm that the major issues have been addressed already.

-- 
Regards,
Pavel Roskin
