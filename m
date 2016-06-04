Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39916 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbcFDPBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 11:01:00 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: b43: don't unconditionally fall back to CCK if the rate is 6MB
 OFDM.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463455534-22512-2-git-send-email-adrian@freebsd.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>,
	b43-dev@lists.infradead.org
Message-Id: <20160604150100.05DFD613CF@smtp.codeaurora.org> (sfid-20160604_170104_168769_DD48E86F)
Date: Sat,  4 Jun 2016 15:00:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> wrote:
> Check the current PHY operating mode (gmode) to see if we should
> fall back from 6MB OFDM to 11MB CCK.  For 5GHz operation this isn't
> allowed.
> 
> Note, the fallback lookup is only done for RTS rates; normal fallback
> rates are done via mac80211 and aren't affected by this change.
> 
> Signed-off-by: Adrian Chadd <adrian@freebsd.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

d0b03439f784 b43: don't unconditionally fall back to CCK if the rate is 6MB OFDM.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9108351/

