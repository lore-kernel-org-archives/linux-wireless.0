Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0LAPPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:15:08 -0500
Date: Wed, 1 Dec 2010 10:09:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthil.lnx@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: [PATCH 2/2] ath9k: Fix STA disconnect issue due to received MIC
 failed bcast frames
Message-ID: <20101201150945.GA2441@tuxdriver.com>
References: <1291128560-2741-1-git-send-email-senthilkumar@atheros.com>
 <20101201111713.GA1623@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101201111713.GA1623@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 04:47:13PM +0530, Senthil Balasubramanian wrote:
> John
> 
> Can you please revert this patch and apply my v2 patch? My apologies
> for the trouble...
> 
> I overlooked an issue in one place and for some reason my testing
> also did not show any issue... Thanks to Felix for pointing this
> issue..
> 
> Thanks
> Senthil

Can you send an follow-on patch instead?  Rebasing to is a PITA.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
