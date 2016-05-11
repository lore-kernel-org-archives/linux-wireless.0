Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51996 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbcEKQeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 12:34:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: [PATCH 12/41] iwlwifi: trans: don't call the trans-specific ref/unref directly
References: <1462910585.25219.7.camel@coelho.fi>
	<1462910797-20303-1-git-send-email-luca@coelho.fi>
	<1462910797-20303-12-git-send-email-luca@coelho.fi>
Date: Wed, 11 May 2016 19:34:30 +0300
In-Reply-To: <1462910797-20303-12-git-send-email-luca@coelho.fi> (Luca
	Coelho's message of "Tue, 10 May 2016 23:06:08 +0300")
Message-ID: <87y47geep5.fsf@kamboji.qca.qualcomm.com> (sfid-20160511_183448_874088_73FD4BDF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> It's cleaner to always call the iwl_trans_ref/unref() functions
> instead of sometimes calling the trans-specific ops directly.  This
> also prepares for moving some of the code from the trans-specific ops
> to the common trans code.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

A duplicate S-o-b. Not a problem, just wanted to point it out.

-- 
Kalle Valo
