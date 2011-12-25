Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56183 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1LYXpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 18:45:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RexkZ-0003NA-3S
	for linux-wireless@vger.kernel.org; Mon, 26 Dec 2011 00:45:07 +0100
Received: from 66.sub-75-192-52.myvzw.com ([75.192.52.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 00:45:07 +0100
Received: from rmiller61k by 66.sub-75-192-52.myvzw.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 00:45:07 +0100
To: linux-wireless@vger.kernel.org
From: Bob Miller <rmiller61k@gmail.com>
Subject: Re: Fedora 16 Wireless Connection Problem
Date: Sun, 25 Dec 2011 23:42:54 +0000 (UTC)
Message-ID: <loom.20111226T003824-126@post.gmane.org> (sfid-20111226_004534_847608_2F1D9DC4)
References: <CADiUXRwb+ktGmyuMxMcXhZkpbhy=kAkOJcTLpJYRcaFFSRMnMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mammar <mammar@...> writes:

> 
> I have Dell Inpiron N5010 with Broadcom Corporation BCM4313
> 802.11b/g/n Wireless LAN Controller.
> 
> My OS is Fedora 16 64-bit. I have installed the following drivers for
> my wireless controller, everything is working great until yesterday.
> Now whenever i try to connect to wirless connection, it failed.
> 
>
> 
> Can anyone help me?
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

What kernel are you using?

The latest kernel (kernel-3.1.6-1.fc16.x86_64) seems to have broken the wireless
on my HP laptop. Wireless capability works with the prior version
(kernel-3.1.5-6.fc16.x86_64).



