Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35281 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbZDYOuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:50:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LxjCd-0004ez-4n
	for linux-wireless@vger.kernel.org; Sat, 25 Apr 2009 14:50:03 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2009 14:50:03 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2009 14:50:03 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Edimax EW-7318USG as Access Point?
Date: Sat, 25 Apr 2009 15:44:39 +0100
Message-ID: <wfbpqkvlm0.fsf@calligramme.charmers> (sfid-20090425_165012_274521_294A8398)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm looking for a USB dongle with an external antenna that
will serve both as an access point on my home router (an old
IBM PC running linux off a CF card), and as a WPA capable
station for my IBM X30 laptop when not at home. The Edimax
EW-7318USG looks promising, but the wiki at
<http://wireless.kernel.org/en/users/Drivers> has but a
qualified yes under AP for the rt73usb driver.

Before I buy one, please can someone give me an idea of what
yes[footnote: under development] means? Is it an optimistic
version of "no[footnote: under development]", or a
pessimistic version of "yes, it works barring a minor hitch
or two"? I'm not averse to building kernel modules, possibly
applying experimental patches, but I don't want to keep
having to do that for years, and if it doesn't work at all
now, I'd rather wait for further developments before
choosing (maybe a different dongle is more likely to work?).

The other side of the issue is WPA: the airo card on the
laptop works OK with WEP, but there doesn't seem to be any
prospect of WPA on that, unless I mis-googled.

--=20
J=C3=B3n Fairbairn                                 Jon.Fairbairn@cl.cam=
=2Eac.uk

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
