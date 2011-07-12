Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr19.hinet.net ([168.95.4.119]:48291 "EHLO msr19.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631Ab1GLDXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 23:23:04 -0400
Date: Tue, 12 Jul 2011 11:21:03 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, WLAN FAE <wlanfae@realtek.com>
Subject: Re: [PATCH 0/2] staging: r8712u: Set ESSID/AP now possible before
 interface is brought Up.
Message-ID: <20110712032103.GA6847@internetdog.org> (sfid-20110712_052307_984828_08EC0D0B)
Reply-To: ali@internetdog.org
References: <1310378876-1311-1-git-send-email-ali@internetDog.org>
 <4E1B1D60.9030509@lwfinger.net>
 <20110712020049.GA6364@internetdog.org>
 <4E1BB788.2010405@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E1BB788.2010405@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 11, 2011 at 09:55:04PM -0500, Larry Finger wrote:
> On 07/11/2011 09:00 PM, Ali Bahar wrote:
> >On Mon, Jul 11, 2011 at 10:57:20AM -0500, Larry Finger wrote:
> >>On 07/11/2011 05:07 AM, Ali Bahar wrote:
> >>>These are updates to how the 'bup' flag is handled. The first allows Sets

> >that you may then Ack and send it to Linville -- which, now that you
> >have reminded me, would have been Greg KH.

> >OK, so I will re-send these to Greg. Do you not get even a CC?!! You
> >mention none, above, and had offered/expected to review them (in a 3
> >July email.)

> I am one of the driver's authors, not a maintainer. You should send
> any patches for a staging driver to GregKH, and Cc all of the driver
> authors. As I am the only one listed, you only need send these to

So,
  To: Greg
  Cc: Larry
  # and I expect
  Cc: linux-wireless
  # No need for wlanfae@realtek.com


> me. You will need me to ACK the patch, otherwise Greg is unlikely to
> pick it up, particularly as it does more than make cosmetic changes.

Of course.
Thanks,
Ali


> 
> Larry
