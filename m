Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59150 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKTdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:33:37 -0400
Date: Wed, 11 Jul 2012 15:15:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody Hung <Woody.Hung@mediatek.com>
Subject: Re: [PATCH 1/2] rt2x00pci: small 3290 changes cleanup
Message-ID: <20120711191549.GD1937@tuxdriver.com> (sfid-20120711_213340_358801_7BEEFC00)
References: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
 <4FFBFCF0.6030506@bluegiga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FFBFCF0.6030506@bluegiga.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 12:59:12PM +0300, Veli-Pekka Peltola wrote:
> On 07/09/2012 03:41 PM, Stanislaw Gruszka wrote:
> >Fix indention and remove unnecessary brackets and compares.
> 
> Hi,
> 
> Otherwise looks ok but I have a one comment, see below.
> 
> >Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >---
> >  drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++------
> >  1 files changed, 5 insertions(+), 6 deletions(-)
> >
> >diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> >index dd43612..bf0e71e 100644
> >--- a/drivers/net/wireless/rt2x00/rt2800pci.c
> >+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> 
> <snip>
> 
> >@@ -1022,9 +1022,8 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
> >  			rt2800_register_write(rt2x00dev, 0x58, 0x618);
> >  			udelay(REGISTER_BUSY_DELAY);
> >  			count++;
> >-		} else {
> >+		} else
> >  			count = 0;
> >-		}
> 
> I have understood that Linux CodingStyle requires braces on all
> else/if branches if any of those have more than one statement. So I
> would not remove braces here.

I'll just drop that hunk...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
