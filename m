Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43449 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZGXPpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:45:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MUMxC-0005Uy-JV
	for linux-wireless@vger.kernel.org; Fri, 24 Jul 2009 15:45:02 +0000
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 15:45:02 +0000
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 15:45:02 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Fri, 24 Jul 2009 16:43:29 +0100
Message-ID: <wfr5w66q8u.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers> <1247775641.6841.16.camel@mj> <wfzlau7co1.fsf@calligramme.charmers> <1248449030.21715.23.camel@mj> <1248449371.32151.23.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-07-24 at 11:23 -0400, Pavel Roskin wrote:
>
>> I tried to add a link for PCI Express devices, but I don't have
>> permissions to reorganize the Wiki to have a separate table.  
>
>> From the users' perspective, PCI and PCI Express are different busses
>> and should be listed separately.
>
> I'm not sure. The ID spaces are the same really, and users really don't
> distinguish that much, for them PCI-E is just the new PCI technology
> with a different form factor. Kinda like mini-pci vs. pci.

Speaking as a user, I do want to distinguish them: PCIe fits into a
physically different slot from PCI, so having only PCIe slots free, I
really did want to select by socket type. Similarly someone with a PCI
only motherboard would be looking for PCI and not PCIe.

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk

