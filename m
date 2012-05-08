Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49104 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab2EHKzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 06:55:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SRi4O-0002nG-77
	for linux-wireless@vger.kernel.org; Tue, 08 May 2012 12:55:05 +0200
Received: from 202.131.115.146 ([202.131.115.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 12:55:04 +0200
Received: from upadhyay61 by 202.131.115.146 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 12:55:04 +0200
To: linux-wireless@vger.kernel.org
From: Tejas <upadhyay61@gmail.com>
Subject: Is there MII loopback possible in AR7240 based AP91 board?
Date: Tue, 8 May 2012 10:50:02 +0000 (UTC)
Message-ID: <loom.20120508T124840-31@post.gmane.org> (sfid-20120508_125511_464523_F59D7DDC)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we are trying MII loopback in AR7240 based AP91 board. We configure
PORT_CONTROL_REGISTER with (12th bit = MAC_LOOP_BACK = Setting this bit to 1
enables the MAC Loop back function on the MII interface). But the packets are
not getting looped back, we see packets getting forwarded to ethernet ports,
instead of getting looped back.

Can anyone give us any clue weather MII loopback is possible in AR7240 or not? 

