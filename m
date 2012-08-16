Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40474 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2HPA6A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 20:58:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1T1oPN-0001w7-C5
	for linux-wireless@vger.kernel.org; Thu, 16 Aug 2012 02:57:57 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 02:57:57 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 02:57:57 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: make bzImage error
Date: Thu, 16 Aug 2012 00:57:45 +0000 (UTC)
Message-ID: <loom.20120816T025420-929@post.gmane.org> (sfid-20120816_025840_988495_1DA4752F)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I use the command, make bzImage

>/xxx/gen_initramfs_list.sh:cannot open 'y'
>make[1]:***[usr/initramfs_data.cpio] Error 1
>make:***[usr]Error2
Could anyone please tell me what is going on here and how to fix it?thanks

