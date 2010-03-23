Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38778 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0CWIw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 04:52:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Tue, 23 Mar 2010 09:52:56 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <201003222325.35994.mb@bu3sch.de> <4BA80118.1070801@lwfinger.net>
In-Reply-To: <4BA80118.1070801@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003230952.56207.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 March 2010 00:45:28 Larry Finger wrote:
> (2) In drivers/ssb/pci.c, the firmware loading process reads the file, then
> modifies it using the bus address.

No. You don't need firmware loading at all.
udev can just set the mac address through the standard ioctl calls.
Just like how ifconfig and ip can do.

-- 
Greetings, Michael.
