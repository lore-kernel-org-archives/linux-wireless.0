Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36737 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbbEURLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 13:11:22 -0400
Received: by igbpi8 with SMTP id pi8so15346220igb.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 10:11:21 -0700 (PDT)
MIME-Version: 1.0
From: Jason Scatena <jscatena88@gmail.com>
Date: Thu, 21 May 2015 13:11:00 -0400
Message-ID: <CANvVAoyhGCLL7ajGFH91xgNBMZd2kd5P-9v3_PaE+xdmEYYkpQ@mail.gmail.com> (sfid-20150521_191124_967747_B619CB8F)
Subject: Issues with mesh networking path detection
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I am attempting to set up a mesh network between 4 computers with
Atheros 9271 based usb wifi dongles using the ath9k driver.

I followed the guide at: https://github.com/o11s/open80211s/wiki/HOWTO

to set up the network.

When I get all of the computers up and configured they all see each other.
The command "iw dev mesh station dump" shows all the nodes in the
area. However the path selection doesn't seem to work at all. For
instance the command "iw dev mesh mpath dump" returns nothing. However
if I manually add arp entries using the arp command they show up in
the mpath dump.

I am willing to do whatever to troubleshoot however there is very
little documentation that I have been able to find on trouble shooting
these issues. I would also be able to provide a pcap file of the nodes
coming online.

I'm new to the wireless world but have C coding experience and would
be willing to put in the time to learn.

Best,
Jason Scatena
