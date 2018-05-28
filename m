Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:11586 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165991AbeE1OrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 10:47:22 -0400
Date: Mon, 28 May 2018 16:46:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Mack <daniel@zonque.org>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] NFC: st95hf: initialize semaphore and mutex earlier
Message-ID: <20180528144656.GB29700@zurbaran.ger.intel.com> (sfid-20180528_164730_649894_9CC5990E)
References: <20180516133247.25986-1-daniel@zonque.org>
 <6eed2f2f-b3cc-0582-220c-e4ccd2175fd7@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6eed2f2f-b3cc-0582-220c-e4ccd2175fd7@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Mon, May 28, 2018 at 04:35:15PM +0200, Daniel Mack wrote:
> On Wednesday, May 16, 2018 03:32 PM, Daniel Mack wrote:
> > 'rm_lock' and 'exchange_lock' need to be ready before the IRQ handler has a
> > chance to fire.
> > 
> > This fixes the oops below.
> 
> Nobody seems to be interested in these. Davem, can you take them through
> your tree or is there anyone else I can ping?
I'm going to gather all pending NFC patches this week. I'll take that
one.

Cheers,
Samuel.
