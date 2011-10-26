Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54274 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1JZWY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 18:24:29 -0400
Received: by ggnb1 with SMTP id b1so2018985ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 15:24:29 -0700 (PDT)
Message-ID: <4EA888AE.30406@lwfinger.net> (sfid-20111027_002439_797599_033EE88F)
Date: Wed, 26 Oct 2011 17:24:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Switching ssb to read 8-bit quantities from SPROM
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tested the effects of changing ssb to read the SSPROM in 8-bit hunks rather 
than as 16-bit words in the manner that was just submitted for brcmsmac. 
Although this simplifies the calculation of the crc8, it only reduced the size 
of the module by 31 bytes, thus I will not be submitting the patch.

When the library version of the crc8 routine was used rather than the one built 
into ssb, the size of the driver was increased by 17 bytes.

Larry
