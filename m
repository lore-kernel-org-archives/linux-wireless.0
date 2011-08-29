Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:37917 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab1H2Hwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 03:52:53 -0400
Received: from [195.4.92.25] (helo=15.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QxweI-0004ws-8p
	for linux-wireless@vger.kernel.org; Mon, 29 Aug 2011 09:52:50 +0200
Received: from p4fde011f.dip0.t-ipconnect.de ([79.222.1.31]:59643 helo=mail.maya.org)
	by 15.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #5)
	id 1QxweI-0006bQ-1X
	for linux-wireless@vger.kernel.org; Mon, 29 Aug 2011 09:52:50 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p7T7qkjX003178
	for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 09:52:47 +0200
Message-ID: <4E5B455D.5030301@01019freenet.de> (sfid-20110829_095256_621862_FCA0C0CC)
Date: Mon, 29 Aug 2011 09:53:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Additional, unrecognized frames containing undefined data in AP mode
 with rt2800usb
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just air traced rt2800usb (compat-wireless-3.1-rc1-1, rt3572 based
device (Linksys WUSB600N v2)) running in AP mode. I could see casual
(1-3 per second) additional frames ("Unrecognized (Reserved frame)")
during beaconing (nothing else has been done), which don't have a MAC
address but contain undefined (?) data.

The size of these complete frames was either 124 bytes or 1148 bytes.

Could you please fix this issue?



Kind regards,
Andreas
