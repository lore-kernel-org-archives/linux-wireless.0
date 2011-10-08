Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56192 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab1JHQY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 12:24:29 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RCZhK-0004As-MX
	for linux-wireless@vger.kernel.org; Sat, 08 Oct 2011 18:24:26 +0200
Received: from p5DD2D318.dip.t-dialin.net ([93.210.211.24])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 18:24:26 +0200
Received: from toddy by p5DD2D318.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 18:24:26 +0200
To: linux-wireless@vger.kernel.org
From: Toddy <toddy@fishpost.de>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Sat, 8 Oct 2011 16:24:14 +0000 (UTC)
Message-ID: <loom.20111008T181929-517@post.gmane.org> (sfid-20111008_182432_526172_19EC56B6)
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

thanks for the quick reply! Yes I know this version is a bit older, but when I
use the newest compat-wireless (eg.
http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2011-10-07.tar.bz2)
the driver loads but some features like monitor-mode and packet injection
doesn't work. The listing of available networks (with airodump) doesn't work
too. Usually I have 13 channels because I live in Germany but if I use the
newest driver I have only 11 channels. But if I use the older compat-wireless
package all works fine.

Toddy

