Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4729 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754310AbdKIX03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:26:29 -0500
Date: Fri, 10 Nov 2017 00:26:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH 00/23] neard: Support TI Std & Pro tags, fixups, etc.
Message-ID: <20171109232626.GB4161@zurbaran.ger.intel.com> (sfid-20171110_002637_776428_7B40AEEF)
References: <20170615182516.4508-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Thu, Jun 15, 2017 at 11:24:53AM -0700, Mark Greer wrote:
> This is an assortment of commits that make some fixups, do some general
> tightening of NDEF data checking, add support for TI Standard and Pro
> Type 5 tags, and stop issuing the Read Multiple Blocks command when
> formatting a Type 5 tag.  The reasoning for each change is in the
> individual commit descriptions.
> 
> For convenience, a branch with these commits is available in the
> submit/updates-v1 branch here:
> 
> 	https://github.com/animalcreek/neard.git
Applied, thanks.

Cheers,
Samuel.
