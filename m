Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:37601 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbZKJRmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 12:42:45 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KSW009KHL5E8Y70@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Tue, 10 Nov 2009 18:12:50 +0100 (CET)
Message-id: <4AF99EF9.4040408@nets.rwth-aachen.de>
Date: Tue, 10 Nov 2009 18:12:25 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: ath5k-devel@lists.ath5k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

is there any reason the packet is dropped and "NETDEV_TX_OK" is returned,
in this case?
Seems pretty stupid to me, because now we are randomly dropping
packets before kernel queuing (qdisc etc) can handle them,
or am I missing something?

Best regards,
Arnd
