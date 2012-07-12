Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33003 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627Ab2GLCw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 22:52:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Sp9Vy-0004lC-Dg
	for linux-wireless@vger.kernel.org; Thu, 12 Jul 2012 04:52:26 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 04:52:26 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 04:52:26 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: problem with installing the kernel
Date: Thu, 12 Jul 2012 02:52:15 +0000 (UTC)
Message-ID: <loom.20120712T044726-224@post.gmane.org> (sfid-20120712_045234_739947_F6950FCF)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I add something to the wireless-testing and then run:
> make modules
> make bzImage

it seems all fine. but could not go any further
# make modules_install
rm:invalid option -- '3'
Try 'rm -- help' for more information
make : *** [_modinst_] Error 1

Could anyone please help me with the situation? 
 The version of the linux is 3.4.4-3.fc17.x86_64 #1


