Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49769 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2GHR7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 13:59:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Snvl7-0008CP-C8
	for linux-wireless@vger.kernel.org; Sun, 08 Jul 2012 19:59:01 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 19:59:01 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 19:59:01 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: make =?utf-8?b?bW9kdWxlc19pbnN0YWxs?= error
Date: Sun, 8 Jul 2012 17:58:49 +0000 (UTC)
Message-ID: <loom.20120708T195348-706@post.gmane.org> (sfid-20120708_195908_218116_1871092E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After I run: make modules make bzImages successfully, I tried to make 
modules_install but could not go any further.
# make modules_install
rm:invalid option -- '3'
Try 'rm -- help' for more information
make : *** [_modinst_] Error 1

Could anyone please help me with the situation? 
I just add something to the wireless-testing and compile it. The version of the 
linux is 3.4.4-3.fc17.x86_64 #1

Thank you so much.

