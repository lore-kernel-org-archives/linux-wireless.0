Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59777 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab2GKUdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 16:33:32 -0400
Date: Wed, 11 Jul 2012 16:19:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-07-11
Message-ID: <20120711201900.GE1937@tuxdriver.com> (sfid-20120711_223340_918166_2B0C1772)
References: <20120711181721.GC1906@tuxdriver.com>
 <20120711183320.GB1937@tuxdriver.com>
 <CACna6rwN+tBu=BG0TR2udq3PH9qvPg44jJQPGc4G3jH_t2=GjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwN+tBu=BG0TR2udq3PH9qvPg44jJQPGc4G3jH_t2=GjQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2012 at 09:00:50PM +0200, Rafał Miłecki wrote:
> 2012/7/11 John W. Linville <linville@tuxdriver.com>:
> > Ugh, forgot the signature again...
> >
> > On Wed, Jul 11, 2012 at 02:17:22PM -0400, John W. Linville wrote:
> >> Rafał Miłecki (2):
> >>       b43: N-PHY: fix RSSI calibration
> >>       bcma: use custom printing functions
> 
> MIPS users: bcma patch breaks compilation for you (sorry!), please apply
> bcma: fix CC driver compilation on MIPS
> locally before it gets merged.

Ugh...

Dave, I've got that patch queued-up now.  Disregard this request and
I'll send you another one tomorrow or so.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
