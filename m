Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32865 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcEQErx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 00:47:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.
References: <1463455534-22512-1-git-send-email-adrian@freebsd.org>
	<1463455534-22512-2-git-send-email-adrian@freebsd.org>
Date: Tue, 17 May 2016 07:47:45 +0300
In-Reply-To: <1463455534-22512-2-git-send-email-adrian@freebsd.org> (Adrian
	Chadd's message of "Mon, 16 May 2016 20:25:34 -0700")
Message-ID: <877fet8f4e.fsf@kamboji.qca.qualcomm.com> (sfid-20160517_064757_603031_6B7B81B1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> Check the current PHY operating mode (gmode) to see if we should
> fall back from 6MB OFDM to 11MB CCK.  For 5GHz operation this isn't
> allowed.
>
> Note, the fallback lookup is only done for RTS rates; normal fallback
> rates are done via mac80211 and aren't affected by this change.
>
> 	Signed-off-by: Adrian Chadd <adrian@freebsd.org>

Two cosmetic problems: s/\[b43\]/b43: / and remove the tab before the
S-o-b. I can fix them before applying. But most probably I'll apply this
only after the merge window closes, in two weeks or so.

-- 
Kalle Valo
