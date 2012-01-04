Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:59656 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab2ADMbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 07:31:44 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RiQ0L-0008LO-VG
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 13:31:41 +0100
Received: from localhost ([::1]:36910 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RiQ0L-0007o0-RY
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 13:31:41 +0100
Received: from [195.4.92.28] (port=44551 helo=18.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RiPyD-0006LD-Mi
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 13:29:29 +0100
Received: from p4fde00d8.dip0.t-ipconnect.de ([79.222.0.216]:55248 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RiPyD-0000pY-BL
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 13:29:29 +0100
Message-ID: <4F044626.6010806@dualc.maya.org> (sfid-20120104_133147_788038_DD17AB10)
Date: Wed, 04 Jan 2012 13:29:26 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de> <4EFF71F8.6070208@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site>
In-Reply-To: <2766356.70ylY68Gqi@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-15
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:

[...]

> What's the client device connected to the rt2x00 AP? Mind to send a
> 802.11 capture wen this stall happens?

I sent Helmut a trace, which hopefully contains some hints.


Regards,
Andreas
