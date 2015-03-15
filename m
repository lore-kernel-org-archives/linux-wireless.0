Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31690 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbCOIVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:21:31 -0400
Date: Sun, 15 Mar 2015 13:51:13 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, Matthias Kaehlcke <mka@google.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: Fix interpretation of cooling device state
Message-ID: <20150315082112.GB18213@qca.qualcomm.com> (sfid-20150315_092137_010940_2E74BB07)
References: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87d24gyhbc.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87d24gyhbc.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2015 at 05:59:19PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Setting the sysfs attribute ends up configuring the duty cycle,
> > but the interface through which the attribute is exposed
> > (cooling_device) is for setting the throttle/cooling state. This
> > is confusing the user. Hence renaming the cooling device interfaces
> > for better readability.
> >
> > Cc: Matthias Kaehlcke <mka@google.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> The four patches don't apply for some reason, please rebase.
>
Sure. Will send v2 patchset.

-Rajkumar
