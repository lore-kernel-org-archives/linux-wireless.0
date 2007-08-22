Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34143 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759541AbXHVSUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 14:20:42 -0400
Message-ID: <46CC7E78.1050607@lwfinger.net>
Date: Wed, 22 Aug 2007 13:20:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John H." <mistamaila@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: ALERT: firmware change for b43
References: <46C89BF1.5060306@lwfinger.net>	 <20070822145257.GA2926@tuxdriver.com> <46CC5568.5000709@lwfinger.net>	 <20070822171805.GD2926@tuxdriver.com> <46CC7B89.7090906@lwfinger.net> <5b9417770708221110w4c6a7155u8f41e9ea5a0a4a85@mail.gmail.com>
In-Reply-To: <5b9417770708221110w4c6a7155u8f41e9ea5a0a4a85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John H. wrote:
> I'm sorry, I am coming into this rather late.  is this the latest
> firmware for bcm43xx devices at version 4?

This is the new version of fwcutter that extracts firmware with the file names and format needed for 
b43 and b43legacy. As usual, firmware is not being distributed. The README file in the distribution 
has a link to the recommended V3 and V4 drivers from which to extract firmware.

Larry
