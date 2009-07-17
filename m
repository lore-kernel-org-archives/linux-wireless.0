Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54098 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934344AbZGQJ5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 05:57:16 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MRkBl-0007hE-46
	for linux-wireless@vger.kernel.org; Fri, 17 Jul 2009 09:57:13 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:57:13 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:57:13 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Fri, 17 Jul 2009 10:57:02 +0100
Message-ID: <wfy6qniqdt.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <43e72e890907160914gdaa700amb2394d8b859d95cb@mail.gmail.com> <wf63dsmvjg.fsf@calligramme.charmers> <20090716235013.GA26789@jm.kir.nu> <43e72e890907161659h320e6d5fpefe7e0881634addd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com>
writes:

> On Thu, Jul 16, 2009 at 4:50 PM, Jouni Malinen<j@w1.fi> wrote:
>> I don't know how the product list ended up being split that way, but the
>> "laptops" page does actually include number of D-Link adapters,
>> including a PCIe desktop adapter (D-Link DWA-556) that seems to match
>> the request. I saw it at Fry's last week and it does indeed look like a
>> PCIe card.
>
> Sorry that was my doing, I forgot there were a few external cards
> available, I've updated the wiki to reflect this and added a new
> external cards page:
>
> http://wireless.kernel.org/en/users/Drivers/ath9k/products/external

Thanks for that it's much clearer. I've gone through the manufacturers
websites and added what detail I could find about card types. I didn't
use the codes on the page as I couldn't be certain of the details...
maybe should be table format, and probably should either add the codes
or remove the code key.

Since the DWA-556 is about four times the price of the Abit Airpace, it
looks like I'll have to go with the bleeding edge version of ath5k
rather than ath9k.

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


