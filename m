Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:54487 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0JMMiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 08:38:03 -0400
Subject: Re: [RFC: WL1271 DC supprot on OMAP3EVM 0/5]
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext csanjay@mistralsolutions.com" <csanjay@mistralsolutions.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
References: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 15:37:54 +0300
Message-ID: <1286973475.18871.27.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sanjay,

On Wed, 2010-10-13 at 12:57 +0200, ext csanjay@mistralsolutions.com
wrote:
> From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> 
> 
> Sanjay Kumar Champati (5):
>   ARM: Supported MMC 2 features for OMAP3EVM
>   ARM: Supported for Standard SDIO driver on OMAP3EVM for WL1271 DC
>   ARM: Supported for BT enable on OMAP3EVM for WL1271 DC
>   ARM: Added ALSA audio support for WL1271 DC over the PCM interface
>     (OMAP37XX)
>   Supported BT and WLAN configuration for WL1271 over the OMAP37XX

Nobody (or at least most of us) don't even understand what exactly the
purpose of your patchset it.  Can you try to explain what you're trying
to achieve?

Also, you should clean things up, put platform-specific things where
they belong etc.  You really must review your implementation from an
architectural point of view.  If you have questions, ask here first.  In
most cases a patch describes things better than a thousand words, but it
is certainly not the case here. ;)


-- 
Cheers,
Luca.

