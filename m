Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49493 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbZGPRBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 13:01:20 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MRUKc-0001Oi-Jr
	for linux-wireless@vger.kernel.org; Thu, 16 Jul 2009 17:01:18 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 17:01:18 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 17:01:18 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Thu, 16 Jul 2009 18:01:07 +0100
Message-ID: <wf1vogmujw.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On Thu, 2009-07-16 at 09:02 +0100, Jon Fairbairn wrote:
>
>> I've seen adverts for the Abit WLP-01, and elsewhere on the net seen
>> implications that it's 168c:001c, which isn't listed at
>> <http://wireless.kernel.org/en/users/Devices/PCI>, but
>> <http://wireless.kernel.org/en/users/Drivers/ath5k> does list it and
>> says AP mode not working, but mentions
>> <http://madwifi-project.org/wiki/Compatibility/Abit>, which suggest AP
>> mode works with madwifi. What's the current status?
>
> ath5k will support the AP mode in Linux 2.6.31.  It's already in Linux
> 2.6.31-rc3.

Ah, thanks for that. Three questions arise:

Are the pci ids quoted above recognised as needing ath5k?

Is the WLP-01 really ath5k/really have those ids?

The distro I'm using (fedora 11) has 2.6.29 -- will the relevant modules
build for that, or would I have to build a whole 2.6.31?

Thanks.
-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


