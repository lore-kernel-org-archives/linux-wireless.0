Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbcCJOMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:12:10 -0500
Date: Thu, 10 Mar 2016 15:09:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>, dan.g.tob@gmail.com
Subject: Re: New firmware for RT2870
Message-ID: <20160310140955.GA17840@redhat.com> (sfid-20160310_151215_276519_D5A756C5)
References: <56E08615.9060208@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E08615.9060208@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2016 at 02:22:45PM -0600, Larry Finger wrote:
> In https://bugzilla.kernel.org/show_bug.cgi?id=114151, the OP reports
> improved stability and performance for an RT5370 using a newer firmware that
> came with the driver CD. The logs show this to be version 0.36, whereas the
> version now in linux-firmware is version 0.29.
> 
> I downloaded the firmware from b.k.o. It had very little effect on my
> no-name adapter with ID 148f:3070. It still gets ping losses of 10-15%.
> 
> Should this new version be submitted to linux-firmware? Its provenance seems
> to be sketchy, but submission would likely be legal.

I do not see any reason not to update ralink firmwares in linux-firmware
git tree, however IIRC linux-firmware maintainers prefer to firmware
submission was performed from vendor email addresses.

Stanislaw
