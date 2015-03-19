Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46259 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbbCSVAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 17:00:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YYhYZ-0000ti-Dv
	for linux-wireless@vger.kernel.org; Thu, 19 Mar 2015 22:00:43 +0100
Received: from p508A7FCB.dip0.t-ipconnect.de ([80.138.127.203])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 22:00:43 +0100
Received: from Juergen.Bausa by p508A7FCB.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 22:00:43 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SsO8cmdlbg==?= Bausa <Juergen.Bausa@online.de>
Subject: Re: Broadcom 43340
Date: Thu, 19 Mar 2015 21:00:36 +0000 (UTC)
Message-ID: <loom.20150319T215852-35@post.gmane.org> (sfid-20150319_220054_421246_7120AF5C)
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:
> 
> Do you have brcmfmac driver built with CONFIG_BRCMDBG. If so you can 
> enable debug output by:
> 
> sudo sh -c 'echo 0xd416 > /sys/module/brcmfmac/parameters/debug'
> 

No, it doesnt have dbg set. I will try to compile my own kernel and then come 
back.

Juergen

