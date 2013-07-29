Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42659 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab3G3QzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 12:55:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1V4DCR-0002iq-DT
	for linux-wireless@vger.kernel.org; Tue, 30 Jul 2013 18:55:03 +0200
Received: from 223.228.27.131 ([223.228.27.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 18:55:03 +0200
Received: from priti.pce by 223.228.27.131 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 18:55:03 +0200
To: linux-wireless@vger.kernel.org
From: Priti <priti.pce@gmail.com>
Subject: Re: Passing a custom MAC to ath6kl
Date: Mon, 29 Jul 2013 11:14:44 +0000 (UTC)
Message-ID: <loom.20130729T130127-14@post.gmane.org> (sfid-20130730_185508_631868_2B7DA300)
References: <51D6E484.9060000@digi.com> <87vc4pf1ln.fsf@kamboji.qca.qualcomm.com> <51D6EC90.40009@digi.com> <51D70A22.20607@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i am looking for a way to update MAC address for ar6103.
i am using compat-wirless-3.4.rc3-1 package and linux 2.3.31 kernel.
i have tried many ways to hard code the mac address value just to see the
change in mac address.i am able to see the updated mac address while giving
the ifconfig command,but my device is not sending any packet and not getting
IP address.
i have been trying to dig each and every source file in ath6kl folder but
not able to figure out why i am not able to change the mac address.

can any one please tell me the exact steps to achieve this.
it will be really helpful.

THanks,
Priti

