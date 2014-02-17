Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45150 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaBQQdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 11:33:17 -0500
Date: Mon, 17 Feb 2014 17:33:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	frankyl@broadcom.com
Subject: Re: brcmfmac NVRAM files
Message-ID: <20140217163315.GA22010@zurbaran> (sfid-20140217_173320_956599_DCB98A05)
References: <20140217150640.GJ18868@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140217150640.GJ18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 17, 2014 at 04:06:40PM +0100, Samuel Ortiz wrote:
> Hi Arend,
> 
> I'm trying to use a 43241 SDIO chip here, and it fails asking for the
> .txt file (brcmfmac43241b4-sdio.txt). This seems to be an NVRAM map
> file, but I could not find either a template on linux-firmware or any
> kind of documentation about it.
> 
> How do distro handle that ? Are they expected to build their own, or is
> it completely OEM pecific ?
Adding Franky to the Cc list.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
