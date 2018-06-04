Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35628 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbeFDFfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:35:41 -0400
Date: Mon, 4 Jun 2018 07:35:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Mack <daniel@zonque.org>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] NFC: st95hf: initialize semaphore and mutex earlier
Message-ID: <20180604053535.GC31498@zurbaran.ger.intel.com> (sfid-20180604_073802_780154_893DF941)
References: <20180516133247.25986-1-daniel@zonque.org>
 <6eed2f2f-b3cc-0582-220c-e4ccd2175fd7@zonque.org>
 <20180528145000.GA11829@zurbaran.ger.intel.com>
 <a8713f8c-a3be-6248-9fd6-b7e91048c9b7@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a8713f8c-a3be-6248-9fd6-b7e91048c9b7@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Mon, May 28, 2018 at 09:39:01PM +0200, Daniel Mack wrote:
> On Monday, May 28, 2018 04:50 PM, Samuel Ortiz wrote:
> > Hi Daniel,
> > 
> > On Mon, May 28, 2018 at 04:35:15PM +0200, Daniel Mack wrote:
> > > On Wednesday, May 16, 2018 03:32 PM, Daniel Mack wrote:
> > > > 'rm_lock' and 'exchange_lock' need to be ready before the IRQ handler has a
> > > > chance to fire.
> > > > 
> > > > This fixes the oops below.
> > > 
> > > Nobody seems to be interested in these. Davem, can you take them through
> > > your tree or is there anyone else I can ping?
> > I'm going to gather all pending NFC patches this week, including this
> > one.
> > They will land in either the nfc-next or nfc-fixes tree.
> 
> Ah, perfect. Sorry for nagging. I just wanted to be sure they're not
> forgotten :)
Both patches applied to nfc-next now, thanks.

Cheers,
Samuel.
