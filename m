Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41530 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZGXHj3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 03:39:29 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MUFNI-0002Hg-Es
	for linux-wireless@vger.kernel.org; Fri, 24 Jul 2009 07:39:28 +0000
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 07:39:28 +0000
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 07:39:28 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Fri, 24 Jul 2009 08:39:10 +0100
Message-ID: <wfzlau7co1.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers> <1247775641.6841.16.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On Thu, 2009-07-16 at 18:01 +0100, Jon Fairbairn wrote:
>> The distro I'm using (fedora 11) has 2.6.29 -- will the relevant modules
>> build for that, or would I have to build a whole 2.6.31?
>
> You can build compat-wireless, which includes the latest ath5k driver
> backported from the wireless-testing kernel.  Alternatively, you can
> build madwifi (be sure to use the trunk snapshot).

OK! I bought one and with compat-wireless-2009-07-20 + hostapd 0.6.9 it
seems to work. I haven't done much testing yet, but I can certainly
connect to it from an eee pc 901 and from a Macbook Air (and from my IBM
X30 so long as I don't use WPA).

For reference: The box says "abit airpace wifi", "pci-e wi-fi card",
"WLP01WCG121095 V0.0B" (on a sticker; this is the only place on the
outside of the box that mentions WPL01), "EAN 4 710933 354359", "UPC 8
43323 00028 5"

lspci -nn says
04:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x
           802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)

Does that want to go on the wiki? (I can't access it right now:
http://wireless.kernel.org/en/users/Devices * Connection to 83.246.72.84
Failed )

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


