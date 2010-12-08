Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35833 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab0LHOpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 09:45:09 -0500
Date: Wed, 8 Dec 2010 09:33:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ath: Missed to clear key4 of micentry
Message-ID: <20101208143341.GD2423@tuxdriver.com>
References: <1291818665-6660-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291818665-6660-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 08:01:05PM +0530, Rajkumar Manoharan wrote:
> key4 of micentry is used, if ATH_CRYPT_CAP_MIC_COMBINED is set.
> But is not cleared on key cache reset.
> 
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Which results in...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
