Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1DORSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 13:18:55 -0400
Received: by bwz15 with SMTP id 15so2352299bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 10:18:53 -0700 (PDT)
Message-ID: <4DA87DFA.1020908@googlemail.com>
Date: Fri, 15 Apr 2011 19:18:50 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [iw, ath5k] setting of antennas
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Thanks to Bruno Randolf, John Linville, Johannes Berg and other, it is
possible to set transmission or reception antennas with ath5k. But:

Is it only possible to set the bitmap of used antennas via iw(8) like this:

phy <phyname> set antenna <bitmap> | all | <tx bitmap> <rx bitmap>

Or is there a way to this with an IOCTL or similar in an own program?

I do also know of the (deprecated) way to this via debugfs, but I'd
really like to do it on my own in a C-program as part of other things to
be done. I wouldn't like this operation to be performed with a
system(3)-call of iw(8).

Any hints? I could not find documentation about this topic...

Best regards,
Dennis
