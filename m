Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36420 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1JRVub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 17:50:31 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RGHYK-0008Lx-00
	for linux-wireless@vger.kernel.org; Tue, 18 Oct 2011 23:50:28 +0200
Received: from host42-179-dynamic.1-87-r.retail.telecomitalia.it ([87.1.179.42])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 23:50:27 +0200
Received: from gaigo88 by host42-179-dynamic.1-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 23:50:27 +0200
To: linux-wireless@vger.kernel.org
From: v4mp <gaigo88@hotmail.it>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Tue, 18 Oct 2011 21:50:12 +0000 (UTC)
Message-ID: <loom.20111018T233233-298@post.gmane.org> (sfid-20111018_235035_093467_2EA4D85D)
References: <4E77F631.3030202@googlemail.com> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org > <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwfinger.net> <loom.20111018T143746-420@post.gmane.org> <loom.20111018T150303-359@post.gmane.org> <4E9D9953.3020601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

yes, i know that the awus036h uses a different driver, 
i just wanna say that it 
has no conflicts with xhci_hcd as happen when loading 
the rtl8192cu driver for the 036nhr

the driver i downloaded from realtek is what you can find here
http://www.alfa.com.tw /in/front/bin/ ptlist.phtml?Category=105397
for the awus036nhr, and it works fine without any kind of errors,
 detection of APs and connections

every compat wireless i download does not with rtl8192cu and my alfa,
i tested all the specific kernel version of compat-wireless and the latest 
bleeding edge compat wireless, i'm hating this fuckin errors :)





