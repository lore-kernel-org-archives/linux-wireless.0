Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:52190 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2AYNb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 08:31:29 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rq2wh-0007nq-LC
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 14:31:27 +0100
Received: from localhost ([::1]:42204 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rq2wh-0000vQ-KK
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 14:31:27 +0100
Received: from [195.4.92.12] (port=50590 helo=2.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rq2uV-000831-LH
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 14:29:11 +0100
Received: from [2002:4fde:14a5:2:5054:ff:feb8:40bd] (port=59249 helo=mail.maya.org)
	by 2.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rq2uV-0007xw-6B
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 14:29:11 +0100
Message-ID: <4F20039C.2030809@01019freenet.de> (sfid-20120125_143132_856571_463F873A)
Date: Wed, 25 Jan 2012 14:29:00 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k get's completely knocked out by rt3572 device
References: <4F1EF618.6080108@01019freenet.de> <13411135.eH6opTgxBo@helmutmobil.site> <4F1FBA09.3000003@01019freenet.de> <4F1FDEAE.2020009@01019freenet.de> <CAGXE3d9Lrk+ginqqbxVM+v_+fpnhu=y_R=TGdyoy+ZWuLtfbtQ@mail.gmail.com>
In-Reply-To: <CAGXE3d9Lrk+ginqqbxVM+v_+fpnhu=y_R=TGdyoy+ZWuLtfbtQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> On Wed, Jan 25, 2012 at 11:51 AM, Andreas Hartmann 
> <andihartmann@01019freenet.de> wrote:
>> As promised, I repeated the test before with another AP. The
>> destination host of netperf was the same. See below!
> 
> So, in total it looks a little bit better then with the rt2800pci AP 
> but still the airtime is distributed not equally but the Ralink STA
> seems to get a higher amount of airtime :(.

Well, the amount of sent data from AP -> STA is much higher with rt2860
based AP. So, the density is higher as with the Linksys WAP. Could this
be a problem for ath9k? But ath9k runs very well, if the conditions are
better (not as much disruption).

The rt2860 based AP feels smoother than the Linksys WAP. If the reverse
way could be optimized, it would be a great AP :-).

But you have to take into consideration, that the rt2860 AP resides
directly on PCI and isn't restricted to fast ethernet. The throughput
peaks with the rt2860 based AP where about 14 MBit/s (-> xosview). These
couldn't be seen with the Linksys WAP.

> 
> Maybe the ralink driver treats the channel access parameters
> differently?

Don't know.


Andreas
