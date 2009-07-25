Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:57090 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZGYHqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 03:46:18 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MUbxO-0006zY-A3
	for linux-wireless@vger.kernel.org; Sat, 25 Jul 2009 07:46:14 +0000
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 07:46:14 +0000
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 07:46:14 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Sat, 25 Jul 2009 08:46:03 +0100
Message-ID: <wfiqhh6w90.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers> <1247775641.6841.16.camel@mj> <wfzlau7co1.fsf@calligramme.charmers> <1248449030.21715.23.camel@mj> <1248449371.32151.23.camel@johannes.local> <1248450733.21715.26.camel@mj> <1248451197.32151.26.camel@johannes.local> <1248451440.21715.27.camel@mj> <1248451757.32151.27.camel@johannes.local> <wfmy6u6opl.fsf@calligramme.charmers> <1248452675.32151.31.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-07-24 at 17:16 +0100, Jon Fairbairn wrote:
>> (In the "asking for the moon on a stick" department, it would be handy
>> to have a table somewhere with "supported features" and "form factor"
>> dropdowns, so that I could have selected "AP" and "PCIe" and get the
>> card I now have ;-)

[...]

> I'm starting to think we should remove all the numbers (pci vendor,
> product, subvendor, subsystem) in favour of more interesting information
> like that.

That would be good -- I suspect that the number of people who understand
the purpose of the ids is rather smaller than the number of people who
just want wireless of some description (though the numeric stuff needs
to be somewhere).

> However, as far as AP is concerned, how about we just add a little help
> text that explains that you should look on the Drivers page to see
> whether it supports what you need, and then select by driver? We could
> make the driver table better to allow filtering.

That would be a help.  Mind you, I'm now a satisfied customer hoping he
won't have to look for AP information for a while...

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


