Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54451 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab3A1OWe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 09:22:34 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/37] iwlwifi: add the MVM driver
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
	<1359377405.8120.16.camel@jlt4.sipsolutions.net>
Date: Mon, 28 Jan 2013 16:22:33 +0200
In-Reply-To: <1359377405.8120.16.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Mon, 28 Jan 2013 13:50:05 +0100")
Message-ID: <87pq0pcrpy.fsf@purkki.adurom.net> (sfid-20130128_152241_735623_D1E09025)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Question for the list ...
>
> Internally, we've identified patches to this new driver as
>
> "iwlwifi (MVM):"
>
> rather than just "iwlwifi:"
>
> We can continue doing so (and would probably also tag patches with
> "iwlwifi" for core and "iwlwifi (DVM)" for the DVM part.
>
> Would "iwlmvm"/"iwldvm"/"iwlwifi" make more sense as that's the module
> names? It's harder to filter though, I guess.

I would use this:

"iwlwifi: mvm: fix foo"

I don't remember where I saw that style first but I liked it.

-- 
Kalle Valo
