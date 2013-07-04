Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41363 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab3GDNXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 09:23:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UujVl-0004KR-CF
	for linux-wireless@vger.kernel.org; Thu, 04 Jul 2013 15:23:49 +0200
Received: from 24.212.241.19 ([24.212.241.19])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 15:23:49 +0200
Received: from dennisn by 24.212.241.19 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 15:23:49 +0200
To: linux-wireless@vger.kernel.org
From: Dennis New <dennisn@dennisn.dyndns.org>
Subject: configuring Generic Information Elements (genie)
Date: Thu, 4 Jul 2013 09:23:29 -0400
Message-ID: <20130704092329.a9f5ce506984b78a878fb4bf@dennisn.dyndns.org> (sfid-20130704_152357_023575_C254BBF0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there a way to configure (i.e. disable) the "generic information
elements" that are listed, for example, by "iwlist genie" ?

I have an open ad-hoc network, and whereas one of my wifi cards shows
"no generic IE (Operation not supported)", and works fine, my other
card shows:

 IE: IEEE 802.11i/WPA2 Version 1
 Group Cipher : CCMP
 Pairwise Ciphers (1) : CCMP
 Authentication Suites (1) : PSK

which seems to be causing problems on some (probably buggy) machines
that incorrectly think it's using WPA2.

