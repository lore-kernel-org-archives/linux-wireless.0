Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48844 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2GLENU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 00:13:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SpAmB-0007uv-Ex
	for linux-wireless@vger.kernel.org; Thu, 12 Jul 2012 06:13:15 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 06:13:15 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 06:13:15 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: Re: problem with installing the kernel
Date: Thu, 12 Jul 2012 04:13:05 +0000 (UTC)
Message-ID: <loom.20120712T060947-580@post.gmane.org> (sfid-20120712_061325_609725_82AC266C)
References: <loom.20120712T044726-224@post.gmane.org> <4FFE437E.8080008@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> On 07/11/2012 09:52 PM, Ouyang wrote:
> > I add something to the wireless-testing and then run:
> >> make modules
> >> make bzImage
> >
> > it seems all fine. but could not go any further
> > # make modules_install
> > rm:invalid option -- '3'
> > Try 'rm -- help' for more information
> > make : *** [_modinst_] Error 1
> >
> > Could anyone please help me with the situation?
> >   The version of the linux is 3.4.4-3.fc17.x86_64 #1
> 
> Are you building the kernel as root? That is a terrible policy!!!
> 
> You should run "make" as a regular user, and follow that with "sudo make 
> modules_install install". If that fails, you need to ask about the problem at 
> Fedora. The standard kernel does the modules installation without any 
problems.
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Thank you so much for the reply. Sorry that I run "make" as a root. I am new 
with linux and I am sure I won`t make the same mistake in the future. By the way 
, why it tells me about try "rm -- help"? I really do not know what does it 
mean. In what situation will this "rm -- help " come out?

Thanks

Ouyang



