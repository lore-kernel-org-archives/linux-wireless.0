Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3FCPGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:06:46 -0400
Date: Mon, 3 Jun 2013 17:08:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/7] ath9k: Enable WoW only for AR9462
Message-ID: <20130603150846.GB2146@redhat.com> (sfid-20130603_170650_691253_31A380CA)
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
 <1370231369-16241-2-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370231369-16241-2-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Jun 03, 2013 at 09:19:24AM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The only card with which WoW has been tested and verified is
> AR9462. Do not enable it for all cards since WoW is really quirky
> and needs to be tested properly with each chip.

Do this feature will be added back in the future? If so, when? Or there
are some limitations regarding WoW support on older chips?

I'm asking because, we have RHEL customer that request WoWLAN support
for AR9280. I thought this will be matter of backport ath9k driver
from upstream to RHEL, since we have commits that add WoW for AR9002,
including AR9280. But since you're now removing that feature I'm a bit
worried. Will WoW be supported on AR9280, or we should rather ask
customer to use different chip i.e. AR9462 ?

Thanks
Stanislaw

