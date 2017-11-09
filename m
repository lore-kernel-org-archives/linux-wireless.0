Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:22490 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755341AbdKIXi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:58 -0500
Date: Fri, 10 Nov 2017 00:38:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH 0/4] neard: Add support for deactivating tags
Message-ID: <20171109233841.GC4161@zurbaran.ger.intel.com> (sfid-20171110_003928_600309_CBBE778C)
References: <20170616035728.19415-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170616035728.19415-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 15, 2017 at 08:57:24PM -0700, Mark Greer wrote:
> This series adds the ability for client apps to deactivate a currently
> active tag.  Once deactivated, the client can either poll again to
> reactivate the tag or power the adapter off to save power.  These
> changes will not work until the Linux kernel commits submitted under
> the subject, "NFC: Add deactivate target functionality" are committed.
> Those commits can be viewed here:
> 
> 	https://lists.01.org/pipermail/linux-nfc/2017-June/004415.html
> 
> The commits are based on the commits submitted previously under the
> subject, "[PATCH 00/23] neard: Support TI Std & Pro tags, fixups, etc."
> which can be viewed here:
> 
> 	https://lists.01.org/pipermail/linux-nfc/2017-June/004392.html
> 
> For convenience, these commits are available in the 'submit/deactivate_tag-v1'
> branch of this repo on github:
> 
> 	https://github.com/animalcreek/neard.git
> 
> Mark Greer (4):
>   adapter: Make adapter_start_poll() global
>   adapter: Add call indicating whether constant poll is enabled
>   tag: Add Tag deactivate support
>   test: Add option to deactivate tag
All 4 patches applied, thanks.

Cheers,
Samuel.
