Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:8835 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753004AbdKIXFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:05:15 -0500
Date: Fri, 10 Nov 2017 00:05:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH 0/2] NFC: Add deactivate target functionality
Message-ID: <20171109230511.GA4161@zurbaran.ger.intel.com> (sfid-20171110_000521_412337_DED074D2)
References: <20170616033422.18484-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170616033422.18484-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Thu, Jun 15, 2017 at 08:34:20PM -0700, Mark Greer wrote:
> There is currently no way for userspace to deactivate an active target.
> Since the target is active, the adapter cannot be powered down which
> wastes wastes power when the target has been read and isn't needed
> anymore (but remains within range).  To solve this, add a way to
> deactivate a currently active target which will then allow the adapter
> to be powered down.
> 
> To be fully operational, this requires companion patches for neard.
> Those patches will be submitted shortly.
> 
> Mark Greer (2):
>   NFC: digital: Abort cmd when deactivating target
>   NFC: Add NFC_CMD_DEACTIVATE_TARGET support
Both patches applied to nfc-next, thanks.

Cheers,
Samuel.
