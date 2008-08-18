Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:23620 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYHRN0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 09:26:21 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1645187fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 06:26:20 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [rt2x00] rt2800 progress update
Date: Mon, 18 Aug 2008 15:26:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808181526.16974.IvDoorn@gmail.com> (sfid-20080818_152626_371030_96D89B18)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just a small information mail regarding the current status of the rt2800 drivers,
The initial schedule was that last week or at the latest this week, the initial
version of the rt2800 drivers would be released.

But as you might have noticed, this has not happened, which means the project
is behind schedule. The current status is that rt2800usb is capable of
receiving frames (only when using the legacy driver first), and rt2800pci isn't
capable of anything yet.

I am currently putting all focus on rt2800usb because the queue management
is the easiest for that driver, and having that driver working will help in debugging
rt2800pci later.

The fact that rt2800usb is capable of receiving frames after the legacy driver
has been loaded first, means that I am missing one or two instructions which
must be send to the hardware before it will kick in. Unfortunately I have made
little progress in tracking that required instruction. :(

As soon as I have more news, I'll post an update.

Ivo
