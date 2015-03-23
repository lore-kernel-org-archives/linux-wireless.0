Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbbCWUJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 16:09:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ya8fC-0001gb-U6
	for linux-wireless@vger.kernel.org; Mon, 23 Mar 2015 21:09:31 +0100
Received: from p508A7EA6.dip0.t-ipconnect.de ([80.138.126.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 21:09:30 +0100
Received: from juergen.Bausa by p508A7EA6.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 21:09:30 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SsO8cmdlbg==?= Bausa <juergen.Bausa@online.de>
Subject: Re: Broadcom 43340
Date: Mon, 23 Mar 2015 20:09:19 +0000 (UTC)
Message-ID: <loom.20150323T210645-746@post.gmane.org> (sfid-20150323_210940_049102_08B0EEF8)
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com> <loom.20150319T215852-35@post.gmane.org> <550B4241.4040101@broadcom.com> <loom.20150321T213803-13@post.gmane.org> <550EBF89.7030702@broadcom.com> <loom.20150322T210447-841@post.gmane.org> <550FE268.10601@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:

> > I now got it working. Just put 'sleeep 20' before the commands and now it
> > works perfectly.
> 
> Holding the boot for 20s is steep, but I guess a working device trumps a 
> fast boot 
> 

Systemd runs even rc.local in parallel. So it doesn't hold the boot process.

Juergen

