Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:15166 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3G0Qm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jul 2013 12:42:57 -0400
Date: Sat, 27 Jul 2013 18:46:00 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: treeve@scarlet.be, linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Jacob Oursland <jacob.oursland@gmail.com>
Subject: Re: [rt2x00-users] [NETWORKING DRIVERS RT2X00] please add support
 for Asus PCE-N53 (0x1814, 0x5592)
Message-ID: <20130727164600.GA2493@localhost.localdomain> (sfid-20130727_184321_295233_906CCAE8)
References: <51EE8B74.8080206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51EE8B74.8080206@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 23, 2013 at 03:56:04PM +0200, Xose Vazquez Perez wrote:
> Treeve Jelbert wrote:
> 
> > linux-3.10.0 does not support device  (0x1814, 0x5592) Asus PCE-N53 which I 
> > would like to use on with 5GHz network.
> > 
> > #lspci
> > 02:00.0 Network controller: Ralink corp. Device 5592
> >         Subsystem: ASUSTeK Computer Inc. Device 851a
> > 
> > # lspci -d :5592 -nn
> > 02:00.0 Network controller [0280]: Ralink corp. Device [1814:5592]
> 
> RT5592 devices are still unsupported by rt2x00 drivers.
> Stanislaw Gruszka <stf_xl@wp.pl> was working on it.

I did not make any progress :-(  I did some tracing using mmiotrace
to compare with vendor driver, but still did not find difference,
which couse rt2x00 do not work on that adapter.

Stanislaw

