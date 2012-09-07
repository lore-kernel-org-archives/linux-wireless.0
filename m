Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2IGRP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:15:56 -0400
Date: Fri, 7 Sep 2012 19:15:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
Cc: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
	eric.lapuyade@intel.com, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Subject: Re: [linux-nfc] [PATCH v2 1/2] NFC: Remove crc generation from shdlc
 layer
Message-ID: <20120907171553.GH4128@sortiz-mobl> (sfid-20120907_191559_963970_077D0D5C)
References: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <5049E874.8010306@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5049E874.8010306@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldemar, Eric.

On Fri, Sep 07, 2012 at 02:28:36PM +0200, Eric Lapuyade wrote:
> Hi Waldek,
> 
> On 09/07/2012 11:08 AM, Waldemar Rymarkiewicz wrote:
> > Checksum is specific for a chip spcification and it varies
> > (in size and type) between different hardware. It should be
> > handled in the driver then.
> > 
> > Moreover, shdlc spec doesn't mention crc as a part of the frame.
> > 
> > Update pn544_hci driver as well.
> > 
> > Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> > ---
> 
> I have tested this on top of Samuel's nfc-next and it works as expected.
> Thank you.
> 
> Acked-by: Eric Lapuyade <eric.lapuyade@intel.com>
Patch applied, thanks guys.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
