Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934053AbdBQSVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 13:21:37 -0500
Date: Fri, 17 Feb 2017 09:58:35 -0800
From: Kyle McMartin <kyle@infradead.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linux-firmware@kernel.org
Subject: Re: pull-request: iwlwifi firmwares update 2017-02-03
Message-ID: <20170217175835.GS13400@bombadil.infradead.org> (sfid-20170217_192142_672323_179B6606)
References: <1486111291.26003.86.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1486111291.26003.86.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 03, 2017 at 10:41:31AM +0200, Luca Coelho wrote:
> Hi Kyle,
> 
> We have updated some of our old firmware releases and also added a new
> release, version 27, for the newer devices.  More details in the tag
> description.
> 
> Please pull or let me know if there are any issues.
> 

Thanks Luca, pulled.

regards, Kyle

> Cheers,
> Luca.
> 
> 
> 
> The following changes since commit 6d3bc8886517d171068fd1263176b8b5c51df204:
> 
>   Fix permissions on ti-connectivity firmware from 05e9fe59 (2017-01-13 10:14:07 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2017-02-03
> 
> for you to fetch changes up to b689306274099710f9f85eaab584604ca11ee54a:
> 
>   iwlwifi: add -27 firmware for 3168, 7265D, 8000C and 8265 (2017-02-03 10:20:54 +0200)
> 
> ----------------------------------------------------------------
> * update -17 firmware binaries for iwlwifi devices 3260, 7260 and 7265
> * update -22 firmware binaries for iwlwifi devices 7265D, 8000C and 8265
> * add -27 firmware binaries for iwlwifi devices 3168, 7265D, 8000C and 8265
