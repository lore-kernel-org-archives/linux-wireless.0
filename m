Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab2FTIqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:46:25 -0400
Date: Wed, 20 Jun 2012 10:46:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: configure bssid on ASSOC/IBSS change
Message-ID: <20120620084610.GA3579@redhat.com> (sfid-20120620_104632_487872_18F5660E)
References: <1340172657-8699-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340172657-8699-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:40:57AM +0530, Rajkumar Manoharan wrote:
> After the change "mac80211: remove spurious BSSID change flag",
> BSS_CHANGED_BSSID will not be passed on association or IBSS
> status changes. So it could be better to program bssid on ASSOC
> or IBSS change notification. Not doing so, is affecting the
> packet transmission.
> 
> Reported-by: Michael Leun <lkml20120218@newton.leun.net>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: stable@vger.kernel.org # 3.4 + 

