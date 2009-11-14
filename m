Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35696 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKNUYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 15:24:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Wiecki <thomas.wiecki@googlemail.com>
Subject: Re: b43 with 14e4 gives DMA error
Date: Sat, 14 Nov 2009 21:24:32 +0100
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com> <200911021522.38842.mb@bu3sch.de> <4888b8cb0911140349h6b7c9f3du64a633fd6d56829@mail.gmail.com>
In-Reply-To: <4888b8cb0911140349h6b7c9f3du64a633fd6d56829@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911142124.35391.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 November 2009 12:49:25 Thomas Wiecki wrote:
> Does this help?
See the "b43-phy0 ERROR: Fatal DMA error: 0x00000400" thread on the b43 mailing list:
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/thread.html

We're developing a fix there.

This is a proposed fix, but it does not work on all machines.
Some machines seem to need a lower value then 200. You can try 100, for example.
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/006338.html

-- 
Greetings, Michael.
