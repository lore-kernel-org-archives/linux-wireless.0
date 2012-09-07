Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12804 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2IGRQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:16:22 -0400
Date: Fri, 7 Sep 2012 19:16:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
Cc: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>,
	eric.lapuyade@intel.com, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Subject: Re: [linux-nfc] [PATCH v2 2/2] NFC: Correct outgoing frame before
 requeueing
Message-ID: <20120907171617.GI4128@sortiz-mobl> (sfid-20120907_191624_807131_CAE751E3)
References: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <1347008910-11472-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <5049E87B.3000501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5049E87B.3000501@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldemar, Eric,

On Fri, Sep 07, 2012 at 02:28:43PM +0200, Eric Lapuyade wrote:
> Hi Waldek,
> 
> On 09/07/2012 11:08 AM, Waldemar Rymarkiewicz wrote:
> > Driver must handle its data added to the frame, so at this point
> > removeing control field of shdlc frame is enough.
> > 
> > Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> > ---
> 
> I have tested this on top of Samuel's nfc-next and it works as expected
> as well. Thank you.
> 
> Acked-by: Eric Lapuyade <eric.lapuyade@intel.com>
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
