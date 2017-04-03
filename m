Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:48620 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdDCR1H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 13:27:07 -0400
Date: Mon, 3 Apr 2017 13:27:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, kbuild test robot <lkp@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        <linux-ia64@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] nfc: don't be making arch specific unaligned
 decisions at driver level.
Message-ID: <20170403172659.GN2713@windriver.com> (sfid-20170403_192738_738025_0F4BC80D)
References: <201701090839.5u37Hdez%fengguang.wu@intel.com>
 <20170109175222.3162-1-paul.gortmaker@windriver.com>
 <20170401222244.GF22034@zurbaran.ger.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170401222244.GF22034@zurbaran.ger.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Re: [PATCH v2] nfc: don't be making arch specific unaligned decisions at driver level.] On 02/04/2017 (Sun 00:22) Samuel Ortiz wrote:

> Hi Paul,
> 
> On Mon, Jan 09, 2017 at 12:52:22PM -0500, Paul Gortmaker wrote:
> > Currently ia64 fails building allmodconfig with variations of:
> > 

[...]

> > 
> >  drivers/nfc/nfcmrvl/fw_dnld.c  | 2 +-
> >  drivers/nfc/nxp-nci/firmware.c | 2 +-
> >  drivers/nfc/nxp-nci/i2c.c      | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> This build issue is now fixed in nfc-next with a couple of different
> patches.

OK, I'll remove it from my local queue and retest and let you know if I
see any issues still.

Thanks,
Paul.
--

> 
> Cheers,
> Samuel.
