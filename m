Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaLRUEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 15:04:33 -0500
Message-ID: <8f8fcc1c264a41daaa6770d871a12ef3.squirrel@www.codeaurora.org> (sfid-20141218_210437_040642_65DFAD3D)
In-Reply-To: <c1f3352bed1f1a2985a5111a077134a5.squirrel@www.codeaurora.org>
References: <87388d2tbn.fsf@purkki.adurom.net>
    <c1f3352bed1f1a2985a5111a077134a5.squirrel@www.codeaurora.org>
Date: Thu, 18 Dec 2014 22:04:32 +0200
Subject: wireless-drivers patchwork status
From: "Kalle Valo" <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:

> There's no need to CC me on the patches, I can pick the patches from the
> mailing list. Actually in the future I'm hoping to use patchwork[1] for
> managing patches, but my access request is still pending in helpdesk's
> queue. I'll send a separate email once I start using patchwork. For the
> time being I just use email to apply patches.

I got access to patchwork now and I worked with John to make it up-to-date:

https://patchwork.kernel.org/project/linux-wireless/list/

Please let me know if there's something missing from the patch list. The
list does not include iwlwifi, ath10k and ath6kl patches as they are
handled on their own trees.

I also dropped all cfg80211 and mac80211 patches, at least for now. If
Johannes is also interested to use patchwork we can figure how to then
handle the patches. I think patchwork has a feature called "bundles" which
might be a good fit for that.

-- 
Kalle Valo

