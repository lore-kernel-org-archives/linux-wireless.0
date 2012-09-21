Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58782 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab2IUFTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 01:19:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TEveP-0006qD-58
	for linux-wireless@vger.kernel.org; Fri, 21 Sep 2012 07:19:41 +0200
Received: from 108-195-246-110.lightspeed.livnmi.sbcglobal.net ([108.195.246.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2012 07:19:41 +0200
Received: from ilhebe999 by 108-195-246-110.lightspeed.livnmi.sbcglobal.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2012 07:19:41 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: could anyone please help me with make modules error
Date: Fri, 21 Sep 2012 05:19:27 +0000 (UTC)
Message-ID: <loom.20120921T071134-64@post.gmane.org> (sfid-20120921_071942_313735_E3602A18)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>drivers/net/igbvf/igbvf.h: At top level:
>drivers/net/igbvf/igbvf.h:128:15: error: duplicate member ‘page’
>make[3]: *** [drivers/net/igbvf/ethtool.o] Error 1
>make[2]: *** [drivers/net/igbvf] Error 2
>make[1]: *** [drivers/net] Error 2
>make: *** [drivers] Error 2
I just google it and one had met the same problem. Is it possible 
just because of 
the version of gcc?

