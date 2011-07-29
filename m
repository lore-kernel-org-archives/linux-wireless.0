Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64790 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1G2HHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 03:07:03 -0400
Date: Fri, 29 Jul 2011 12:37:12 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/9] ath9k_hw: update PMU to improve ripple issue for
 AR9485
Message-ID: <20110729070710.GC2268@vmraj-lnx.users.atheros.com> (sfid-20110729_090707_781059_C27D5D20)
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311874176-27569-6-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6UZXZ+XD=FyRqwYck=By4203f==K_-2TMPnuSRvR3zr5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6UZXZ+XD=FyRqwYck=By4203f==K_-2TMPnuSRvR3zr5g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 02:14:01PM -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 28, 2011 at 10:29 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Is this a stable fix <etc, etc>, what effects are there to not apply
> this patch ?
>
The commit ebefce3d13f8b5a871337ff7c3821ee140c1ea8a missed to set proper
PMU value to address ripple issue for AR9485. Will v2 send patch with
Ccing to stable.

--
Rajkumar
