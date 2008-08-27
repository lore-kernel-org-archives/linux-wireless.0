Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:10329 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYH0UW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 16:22:59 -0400
Received: by ug-out-1314.google.com with SMTP id c2so1002847ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 13:22:56 -0700 (PDT)
To: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [rt2x00] rt2800 progress update (bad news)
Date: Wed, 27 Aug 2008 22:22:53 +0200
Cc: John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808272222.53719.IvDoorn@gmail.com> (sfid-20080827_222302_546002_E3F8FAB4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Several weeks after the deadline for the initial rt2800 version,
I regret to inform everybody that I still do not have a working driver.

rt2800pci is still incomplete since I have put a lot of focus on the rt2800usb
driver to get at least a single working driver out. Unfortunately rt2800usb
remains very stubborn and refuses. The only success I have had so far is
when I first load the legacy driver and switch to rt2800usb afterwards.
This means I am missing a register initialization or there is a problem with
the register initialization ordering.

The result is that it looks like I will cancel all previously announced deadlines,
and at this time can't give a indication when the first version can be released.
What I can promise is that rt2800usb will be released first, since that driver is most
complete, and I am putting all focus on that driver first.

Ivo
