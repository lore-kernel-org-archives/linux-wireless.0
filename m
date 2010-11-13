Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44166 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0KMSUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:20:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PHKhn-0007im-Sn
	for linux-wireless@vger.kernel.org; Sat, 13 Nov 2010 19:20:03 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 19:20:03 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 19:20:03 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Sat, 13 Nov 2010 18:18:20 +0000 (UTC)
Message-ID: <loom.20101113T191727-421@post.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robie Basak <rb-oss-3@...> writes:

> 
> On 2010-11-12, Larry Finger <Larry.Finger@...> wrote:
> > What does the following log entry signify?
> >
> > Nov 12 16:29:03 tiny kernel: [  160.306731]
> >=>>>>>>>>>>=============================>set power:0,0!
> >
> > On my system, switching to battery does not affect the rtl8187se at all.
> 
> That is consistently showing up every time I switch from AC to battery
> (but not battery to AC) while wireless is on. It does not appear if I
> turn the wireless off, disconnect AC and then turn wireless on again.
> 
> Also for a suspend/resume cycle, it appears only if on battery and
> wireless is on.
> 
> Robie
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


It's good to see that this problem is being examined closely. I have been living
with this issue on my EeePC 701SD for some time and it has been very
frustrating. I can confirm that the same issue Robie describes occur for my
701SD with r8187se wireless card (Fn+F2 causes a kernel panic when turning the
wireless card off -- this doesn't seem to occur when turning it on if the
netbook starts up with the wireless adapter off). This has occured in Ubuntu
versions 9.04 through to 10.10. I recently switched to Debian Squeeze (testing,
beta1), currently running 2.6.32-5-686 kernel and am experiencing an identical
problem. I'm not experienced in debugging this type of issue myself, but would
be happy to test any suggested fixes for the issue and report back results
(though you would need to advise as to how to do this and what to include in
replies).

Regards
James



