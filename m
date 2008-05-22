Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbYEVRuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 13:50:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JzEvS-0005zC-Vc
	for linux-wireless@vger.kernel.org; Thu, 22 May 2008 17:50:03 +0000
Received: from c-67-190-34-252.hsd1.co.comcast.net ([67.190.34.252])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 17:50:02 +0000
Received: from dann.church by c-67-190-34-252.hsd1.co.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 17:50:02 +0000
To: linux-wireless@vger.kernel.org
From: Dann Church <dann.church@cassatt.com>
Subject: Re: iwl4965 - =?utf-8?b?d3BhX3N1cHBsaWNhbnQ=?= can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Date: Thu, 22 May 2008 17:42:31 +0000 (UTC)
Message-ID: <loom.20080522T173929-232@post.gmane.org> (sfid-20080522_195015_507128_F17F01CD)
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>  <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>  <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>  <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>  <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>  <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>  <1210617467.3792.4.camel@X61.DFGI.com> <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@...> writes:

> 
> On Mon, May 12, 2008 at 9:37 PM, Vincent C Jones
> <v.jones@...> wrote:
> >
> > On Mon, 2008-05-12 at 19:50 +0300, Tomas Winkler wrote:
> >
> >> Meanwhile we've reproduced the wpa_supplicant issue...
> >>
> >
> > That is great news. Let me know when it is time to test again...
> 
> Please try this one. I've just pasted that in so it's might be
> white-space-wise broken

I have this same issue running fedora core 9 with a kernel version
2.6.25.3-18.fc9.i686.PAE.  Any chance this patch would work on such a kernel
(assuming I recompiled it from source)?




