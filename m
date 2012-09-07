Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460Ab2IGM2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 08:28:36 -0400
Message-ID: <5049E87B.3000501@linux.intel.com> (sfid-20120907_142838_795636_17554B65)
Date: Fri, 07 Sep 2012 14:28:43 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
CC: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	eric.lapuyade@intel.com
Subject: Re: [linux-nfc] [PATCH v2 2/2] NFC: Correct outgoing frame before
 requeueing
References: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1347008910-11472-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1347008910-11472-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldek,

On 09/07/2012 11:08 AM, Waldemar Rymarkiewicz wrote:
> Driver must handle its data added to the frame, so at this point
> removeing control field of shdlc frame is enough.
> 
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> ---

I have tested this on top of Samuel's nfc-next and it works as expected
as well. Thank you.

Acked-by: Eric Lapuyade <eric.lapuyade@intel.com>

