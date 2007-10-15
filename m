Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41895 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365AbXJPPIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 11:08:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Ihnyg-0005cm-Qm
	for linux-wireless@vger.kernel.org; Tue, 16 Oct 2007 15:05:02 +0000
Received: from userch028.dsl.pipex.com ([62.190.239.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 15:05:02 +0000
Received: from linux by userch028.dsl.pipex.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 15:05:02 +0000
To: linux-wireless@vger.kernel.org
From: Adam Baker <linux@baker-net.org.uk>
Subject: Re: rt2500pci 2.0.9 not working
Date: Mon, 15 Oct 2007 21:49:30 +0000 (UTC)
Message-ID: <loom.20071015T214644-5@post.gmane.org> (sfid-20071016_160812_300281_9777F3E9)
References: <fdqhn4$qab$1@sea.gmane.org> <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com> <1192094159.4770.21.camel@johannes.berg> <200710112005.56101.IvDoorn@gmail.com> <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com> <fent23$9gc$1@sea.gmane.org> <470F89C1.8030406@lwfinger.net> <fevdi0$til$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Better <marcus@...> writes:

> 
> I get download rates of about 9 Mbit, but iwconfig still says the bit rate
> is 1 Mbit, which seems a bit strange.
> 
The rate reported by iwconfig is the upstream rate. The rates won't necessarily
be the same up and downstream.

