Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:29808 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752832AbdFVWVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:21:51 -0400
Date: Fri, 23 Jun 2017 00:21:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH 0/3] NFC: Misc. kernel updates and trf7970a erratum
 handling
Message-ID: <20170622222147.GD21214@zurbaran.ger.intel.com> (sfid-20170623_002154_470975_16A99C82)
References: <20170615174617.1817-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170615174617.1817-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Thu, Jun 15, 2017 at 10:46:14AM -0700, Mark Greer wrote:
> Add a couple minor fixups and remove the trf7970a erratum handling
> in which the last byte in the response to a Type 5 Read Multiple Blocks
> command is discarded.  That handling is moved to the neard daemon where
> there is enough context to do it properly.
> 
> Mark Greer (3):
>   NFC: digital: NFC-A SEL_RES must be one byte
>   NFC: digital: NFC-DEP Target WT(nfcdep,max) is now 14
>   Revert "NFC: trf7970a: Handle extra byte in response to Type 5 RMB
>     commands"
All 3 patches applied, thanks.

Cheers,
Samuel.
