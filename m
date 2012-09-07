Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab2IGM2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 08:28:30 -0400
Message-ID: <5049E874.8010306@linux.intel.com> (sfid-20120907_142834_018886_5031B3C3)
Date: Fri, 07 Sep 2012 14:28:36 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
CC: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	eric.lapuyade@intel.com
Subject: Re: [linux-nfc] [PATCH v2 1/2] NFC: Remove crc generation from shdlc
 layer
References: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldek,

On 09/07/2012 11:08 AM, Waldemar Rymarkiewicz wrote:
> Checksum is specific for a chip spcification and it varies
> (in size and type) between different hardware. It should be
> handled in the driver then.
> 
> Moreover, shdlc spec doesn't mention crc as a part of the frame.
> 
> Update pn544_hci driver as well.
> 
> Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
> ---

I have tested this on top of Samuel's nfc-next and it works as expected.
Thank you.

Acked-by: Eric Lapuyade <eric.lapuyade@intel.com>

