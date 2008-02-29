Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55807 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYB2CDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 21:03:43 -0500
Received: by ug-out-1314.google.com with SMTP id z38so56595ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2008 18:03:40 -0800 (PST)
Message-ID: <b6c5339f0802281803v2035f462ud2de071725af3b48@mail.gmail.com> (sfid-20080229_020347_477851_BE8280B9)
Date: Thu, 28 Feb 2008 21:03:39 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, bruno@thinktube.com
In-Reply-To: <539106d71489e812ae2b9f000e15332022b21d75.1204236793.git.mcgrof@winlab.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
	 <539106d71489e812ae2b9f000e15332022b21d75.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2008 at 5:59 PM, Luis R. Rodriguez
<mcgrof@winlab.rutgers.edu> wrote:
>  * Fix nic_wakeup for PCI-E chips (don't set AR5K_RESET_CTL_PCI bit)
>
>   * Fix dma size setting for PCI-E chips (thanx to Bob Copeland).
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>  Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
>  ---
>   drivers/net/wireless/ath5k/ath5k.h |   10 ++++----
>   drivers/net/wireless/ath5k/hw.c    |   39 ++++++++++++++++++++++++++---------
>   2 files changed, 34 insertions(+), 15 deletions(-)

This version works the same as Nick's patchset for me (pcie 5424 - 0xa3).

Tested-by: Bob Copeland <me@bobcopeland.com>
