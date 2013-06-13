Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34231 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3FMRpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:45:12 -0400
Date: Thu, 13 Jun 2013 13:34:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Subject: Re: Pull request: ath6kl 20130612
Message-ID: <20130613173359.GE3246@tuxdriver.com> (sfid-20130613_194524_707966_A0935F7D)
References: <87d2rrqin8.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d2rrqin8.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 12, 2013 at 09:38:19PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here are few simple patches for ath6kl. We have a suspend crash fix for
> USB from Shafi, use of mac_pton(), a compiler warning fix and a fix for
> module initialisation error path.
> 
> Kalle
> 
> The following changes since commit 3e817f086f06069a23b797ee2279bbae638d5edc:
> 
>   cw1200: remove unused including <linux/version.h> (2013-05-30 14:45:25 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath6kl.git for-linville
> 
> for you to fetch changes up to 37291fc61253cd34db40b7a60be4497db776db41:
> 
>   ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req() (2013-06-01 15:16:33 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
