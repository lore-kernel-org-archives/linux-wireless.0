Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3661 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259AbXDKTr6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 15:47:58 -0400
Date: Wed, 11 Apr 2007 15:40:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	Jouni Malinen <jkm@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Message-ID: <20070411194059.GA2436@tuxdriver.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <200703311137.24379.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703311137.24379.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 31, 2007 at 11:37:19AM -0400, Michael Wu wrote:
> On Monday 26 March 2007 07:38, mohamed wrote:
> > Add basic support for IEEE 802.11n discovery and association.
> >
> > This patch adds support to discover IEEE 802.11n AP and enable
> > association to 802.11n Network. It parses beacon to discover 802.11n
> > IE and include HT capability information element in Association Request
> > Frame.
> > It also call low level driver with the HT capability available during
> > association.
> >
> So.. what happens when the user is using a userspace mlme?

So...Michael is unhappy that I merged this one (and maybe unhappy
about the whole series).

Mohamed, could you address his concern that your patch preclude
userland MLME functionality?  Let's make sure we aren't closing-off
that capability.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
