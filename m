Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51131 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYAXM1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 07:27:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jack" <kflu@cs.nctu.edu.tw>
Subject: Re: Is it possible to receive packets without MAC address filtering?
Date: Thu, 24 Jan 2008 13:26:24 +0100
Cc: linux-wireless@vger.kernel.org
References: <000001c85e80$46d1ab70$d4750250$@nctu.edu.tw>
In-Reply-To: <000001c85e80$46d1ab70$d4750250$@nctu.edu.tw>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801241326.25051.mb@bu3sch.de> (sfid-20080124_122751_349787_CADB2574)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 12:57:20 Jack wrote:
> I'm planning to do a SoftMAC project such as the one based on Madwifi. My

You're doing what? SoftMAC? Yet another 802.11 stack?

> platform is based on bcm43xx (Buffalo WLI2-PCI-G54S). I traced the b43
> device driver for several days. I found that B43_MACCTL_KEEP_CTL and
> B43_MACCTL_BEACPROMISC was set in monitor mode. So, I manually set these two
> bits in the driver. However, it doesn't work like iwconfig the device into
> monitor mode. I use Wireshark to verify it. I also tried to set
> B43_MACCTL_PROMISC bit. It doesn't work either.

You must be doing something wrong. Setting the promisc bits should be enough.

-- 
Greetings Michael.
