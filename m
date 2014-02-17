Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaBQSAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 13:00:47 -0500
Date: Mon, 17 Feb 2014 19:00:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	frankyl@broadcom.com
Subject: Re: brcmfmac NVRAM files
Message-ID: <20140217180033.GM18868@zurbaran> (sfid-20140217_190050_915091_35B13917)
References: <20140217150640.GJ18868@zurbaran>
 <20140217163315.GA22010@zurbaran>
 <53023E51.90202@Uni-Oldenburg.DE>
 <530248DD.1050408@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530248DD.1050408@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, Feb 17, 2014 at 06:37:33PM +0100, Arend van Spriel wrote:
> Hi Bernd,
> 
> The hint to solve this is found on wireless.kernel.org [1] and the
> answer is as Samuel suspects. This file is very board specific so
> OEMs manufacturing/selling the board should provide it either upon
> request or through some distribution like a SDK.
There are several Win8 2-in-1 devices that do run the SDIO Full MAC
chipsets and obviously there is no SDK for those. Which means no distro
will ever be able to run out of the box on those.
I may be completely off the mark here, but isn't there a sensible
template for those guys ? Nothing optimised, but just something that
would at least make things work...

Also, the hint for pre 3.13 kernel is to copy the .bin into a .txt. Is
that still the case for post 3.13 ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
