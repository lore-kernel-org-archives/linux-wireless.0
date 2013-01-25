Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54923 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3AYKhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:37:00 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so441019lbc.7
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 02:36:59 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rt2800 does not support HT40 in managed mode
Date: Fri, 25 Jan 2013 11:36:55 +0100
Message-ID: <2074978.Uifvhs4VDD@sylvesterjr.pats.ua.ac.be> (sfid-20130125_113709_404458_A9B6F8AE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

In a lab setup, we configured rt2800 + hostapd to setup an access point 
in 802.11n 5GHz with HT40. Even though there was no interference, we 
could verify with a Wi-Spy that the network used in fact only a 20MHz wide 
band and iperf showed very low throughput (approx. 10Mbps for a 10m 
line-of-sight connection).

A similar setup in ad-hoc mode resulted in a 40MHz wide band used by the 
network as is to be expected. Any ideas? Is this a (known) bug?

System:
Linux OpenWrt 3.3.8
driver: rt2800pci

Best regards,
Erwin

