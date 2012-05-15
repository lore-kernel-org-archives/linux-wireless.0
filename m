Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58890 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2EOPEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:04:46 -0400
Received: by gglu4 with SMTP id u4so4281898ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 08:04:46 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 May 2012 11:04:45 -0400
Message-ID: <CA+7oygccmq9DY+dR-=__4z_rZ4Sa9d8zmz+6=zX-xsTKdWkFWQ@mail.gmail.com> (sfid-20120515_170451_089218_1944E3C8)
Subject: AR9280 reported signal strengths are flat (comparison with bcm4322 included)
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am experiencing unexpected signal strength values reported by an
AR9280.  Basically, they always tend to be flat no matter how far or
close I am from the device that is transmitting.  Roughly between the
-65 and -55dBm range on average.  The exact AR9280 I am using is:

     Sony UWA-BR100 802.11abgn Wireless Adapter [Atheros AR7010+AR9280]

I have compared this behavior to a bcm4322 and the behavior I see with
the bcm4322 is as expected.  Far away I get low signal strength
values, and close to the device I get high signal strength values
(-20dBm).

Here is a comparison of the two (taken at the same time) as I walk
closer to the transmitter.  I record the signal strength from
wireshark using radiotap header field radiotap.dbm_antsignal.

http://www.flickr.com/photos/gnychis/7203437510/in/photostream

Surprisingly, the average signal strength seems to decrease with the
ar9280 as I get closer, yet remains relatively flat.  The bcm4322
shows a clear increasing trend as I get closer.

Does anyone have any insight as to what might be going on?  I'm using
the most recent firmware and compat-wireless as of May 14, 2012.

Thanks!
George
