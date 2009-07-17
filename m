Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47942 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934343AbZGQKAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 06:00:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MRkEU-0007q4-SM
	for linux-wireless@vger.kernel.org; Fri, 17 Jul 2009 10:00:02 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 10:00:02 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 10:00:02 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Fri, 17 Jul 2009 10:58:08 +0100
Message-ID: <wftz1biqbz.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers> <1247775641.6841.16.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On Thu, 2009-07-16 at 18:01 +0100, Jon Fairbairn wrote:
>
> I cannot guarantee anything, but I think chances are very high.

OK, fair enough.

>> The distro I'm using (fedora 11) has 2.6.29 -- will the relevant modules
>> build for that, or would I have to build a whole 2.6.31?
>
> You can build compat-wireless, which includes the latest ath5k driver
> backported from the wireless-testing kernel.  Alternatively, you can
> build madwifi (be sure to use the trunk snapshot).

Many thanks.  I'll go ahead and order one.

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


