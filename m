Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38938 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab1BHPZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:25:50 -0500
Subject: Re: [PATCH 2/5] iwlwifi: cleanup {iwl,iwl3945}_good_plcp_health
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297153919-18766-2-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:24:05 -0800
Message-ID: <1297178645.20613.28.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> Make plcp health code human readable.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |   83 +++++++-----------
>  drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |  122 +++++++++++----------------
>  drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
>  3 files changed, 80 insertions(+), 126 deletions(-)
> 

Thanks for the clean up, now is much easier to read.

Now we are very close to release the split driver, here you change both
agn and 3945, not sure what is the easier approach will be? push the
patch now, or wait for the driver split finish, then push the patch
after that.

Wey


