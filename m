Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38535 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYICSXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 14:23:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kax0I-0001RS-7M
	for linux-wireless@vger.kernel.org; Wed, 03 Sep 2008 18:22:54 +0000
Received: from apn-77-114-240-162.gprs.plus.pl ([77.114.240.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2008 18:22:54 +0000
Received: from karol by apn-77-114-240-162.gprs.plus.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2008 18:22:54 +0000
To: linux-wireless@vger.kernel.org
From: Karol Szkudlarek <karol@mikronika.com.pl>
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k =?utf-8?b?b24JdWJ1bnR1?= hardy
Date: Wed, 3 Sep 2008 18:22:42 +0000 (UTC)
Message-ID: <loom.20080903T181136-957@post.gmane.org> (sfid-20080903_202309_738139_149963C0)
References: <48BC47C5.2070807@mikronika.com.pl> <1220425598.28282.190.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@...> writes:

> 
> On Mon, 2008-09-01 at 21:51 +0200, Karol Szkudlarek wrote:
> > I'm using Ubuntu 8.04 with compiled 1.2.26k linux wireless driver for 
> > iwl3945 network card on my hp6710b laptop.
> > Script during suspend trying to remove the iwl3945 module and I
> > receive kernel crash.
> > This is repeatable. I attached screenshot of kernel stack. Has
> > somebody of iwl3945 developers can look on it?
> 
> Please try attached patch.
> 
> Thanks,
> -yi
> 
> Attachment (iwl3945_remove.patch): text/x-patch, 1205 bytes


Hello!

I applied the patch but unfortunately still I have a kernel crash.
Look at the screnshoot, stack looks little different:

http://ksi.mikronika.com.pl/~karol/P1180998_s.JPG

Tests I performed with
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2 which
is
compat-wireless-2008-08-06 and git-describe v2.6.26-rc9-14214-g9cb3010
and compat-wireless-2008-07-25 and git-describe v2.6.26-rc9-14207-ga520bdb
with the same result...


Thanks and Regards,
Karol Szkudlarek




