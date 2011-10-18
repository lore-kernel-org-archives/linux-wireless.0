Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55430 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab1JRNaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 09:30:55 -0400
Date: Tue, 18 Oct 2011 09:15:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH] Set IEEE80211_TX_RC_MCS on MCS rates on TX complete.
Message-ID: <20111018131504.GA9630@tuxdriver.com> (sfid-20111018_153059_342603_1137C432)
References: <1318926508-2008-1-git-send-email-pontus.fuchs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318926508-2008-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:28:28AM +0200, Pontus Fuchs wrote:
> IEEE80211_TX_RC_MCS was not set correctly leading to incorrect link
> speed calculation.
> 
> Reviewed-by: Luciano Coelho <coelho@ti.com>

Missing the Signed-off-by...

You probably should be including Luca in the To or Cc as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
