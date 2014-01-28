Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33803 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbaA1JkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 04:40:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1W859G-0004TI-Jg
	for linux-wireless@vger.kernel.org; Tue, 28 Jan 2014 10:40:02 +0100
Received: from ABTS-AP-dynamic-138.164.169.122.airtelbroadband.in ([ABTS-AP-dynamic-138.164.169.122.airtelbroadband.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 10:40:02 +0100
Received: from krama.one by ABTS-AP-dynamic-138.164.169.122.airtelbroadband.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 10:40:02 +0100
To: linux-wireless@vger.kernel.org
From: krama <krama.one@gmail.com>
Subject: radiotap header used in packet injection on monitor mode
Date: Tue, 28 Jan 2014 09:38:02 +0000 (UTC)
Message-ID: <loom.20140128T102749-448@post.gmane.org> (sfid-20140128_104012_188219_2237A897)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In our internal tests we make use of monitor mode (on wireshark) for all the
debugging, especially with security related issues (as packets are
already decrypted).

As i am "injecting the packet on to the network" using a "simulator" built
by own (very similar to the file2air) with the help of lorcon library, there
we are setting the radiotap header as 14 bytes and writing the buffer on to
the sockets and sending the frame.

But when the same frame is captured in wireshark is having different header
length. Why is it happening so ?

Is it the problem in setting the radiotap header arguments in lorcon or what.

Thanks & Regards
Krama







