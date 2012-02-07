Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:39982 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab2BGF7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 00:59:33 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rue5T-0005do-PF
	for linux-wireless@vger.kernel.org; Tue, 07 Feb 2012 06:59:31 +0100
Received: from localhost ([::1]:46001 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rue5T-0000ak-OU
	for linux-wireless@vger.kernel.org; Tue, 07 Feb 2012 06:59:31 +0100
Received: from [195.4.92.17] (port=57302 helo=7.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rue2n-0008RQ-PJ
	for linux-wireless@vger.kernel.org; Tue, 07 Feb 2012 06:56:45 +0100
Received: from [2002:4fde:13c8:2:5054:ff:feb8:40bd] (port=60393 helo=mail.maya.org)
	by 7.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rue2n-0004Tx-EN
	for linux-wireless@vger.kernel.org; Tue, 07 Feb 2012 06:56:45 +0100
Message-ID: <4F30BD13.4080409@maya.org> (sfid-20120207_065937_419238_06252ADC)
Date: Tue, 07 Feb 2012 06:56:35 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: trencan@centrum.cz
CC: linux-wireless@vger.kernel.org
Subject: Re: connection interrupted for rt61pci in master mode
References: <20120128154544.70E060CD@centrum.cz>
In-Reply-To: <20120128154544.70E060CD@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

trencan@centrum.cz schrieb:
> 
> Hello,
> 
> I have RaLink RT2561/RT61 802.11g PCI wireless card and use it in
> master mode as AP. I have latest Mandriva 2011.0 distro with kernel
> 2.6.38.7-desktop-1mnb2. Driver for wifi card is rt61pci. If I connect
> via wifi from another PC then after some small time I get connection
> interrupted and I must disconnect and reconnect again. I tried latest
> compat-wireless-3.3-rc1-2 and also latest hostapd-0.7.3, but still
> same issue. In previous Mandriva version 2010.2 I had kernel
> 2.6.33.7-desktop-2mnb, hostapd-0.6.7 and it worked perfectly. Hostapd
> uses driver=nl80211, mode=g, channel=11.

What about the machine rt61pci runs on? Does the machine have one single
core cpu or is it a multi core / processor machine (smp)?


Regards,
Andreas
