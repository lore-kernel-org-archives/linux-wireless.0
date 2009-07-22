Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60544 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZGVPax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 11:30:53 -0400
Date: Wed, 22 Jul 2009 11:22:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add init values for AR9287 based chipsets.
Message-ID: <20090722152200.GE5276@tuxdriver.com>
References: <20090715031731.GC4613@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090715031731.GC4613@myhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 08:47:31AM +0530, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/initvals.h | 1544 +++++++++++++++++++++++++++++
>  1 files changed, 1544 insertions(+), 0 deletions(-)

This didn't apply after all the rebased patches from Luis.  It looked
deceptively simple to move it, but my "Spidey sense" told me I should
ask you to rebase and resend.  "ath9k: Add support for AR9287 based
chipsets." didn't apply without this, so could you rebase/resend that
one as well?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
