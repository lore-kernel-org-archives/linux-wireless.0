Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbXKOTaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 14:30:22 -0500
Subject: Re: Linux wireless 802.11n progress
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890711141058l722015d0x6a214f2754ad2e4a@mail.gmail.com>
References: <43e72e890711141058l722015d0x6a214f2754ad2e4a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 14:27:12 -0500
Message-Id: <1195154832.15950.9.camel@localhost.localdomain> (sfid-20071115_193026_994843_01E36784)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-14 at 13:58 -0500, Luis R. Rodriguez wrote:
> * Marvel
> 
> All I have found is that they do have 802.11n solutions (TopDog):
> 
> http://www.marvell.com/products/wireless/topdog.jsp

If you are willing to sign an NDA, Marvell could probably send off the
documentation and samples for TopDog.  Linville has specs & hardware,
and even has a git tree, but obviously hasn't had time to look much
further into it.

http://git.kernel.org/?p=linux/kernel/git/linville/marvell.git;a=summary

My take: rewrite the driver from the ground up against mac80211.  Don't
use the vendor driver, but use it as a guide.

Dan


