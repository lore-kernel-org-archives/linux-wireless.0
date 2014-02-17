Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20345 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaBQPGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 10:06:42 -0500
Date: Mon, 17 Feb 2014 16:06:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: brcmfmac NVRAM files
Message-ID: <20140217150640.GJ18868@zurbaran> (sfid-20140217_160645_827072_648561A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I'm trying to use a 43241 SDIO chip here, and it fails asking for the
.txt file (brcmfmac43241b4-sdio.txt). This seems to be an NVRAM map
file, but I could not find either a template on linux-firmware or any
kind of documentation about it.

How do distro handle that ? Are they expected to build their own, or is
it completely OEM pecific ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
