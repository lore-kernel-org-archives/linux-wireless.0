Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3A1Mtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 07:49:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tzo9c-0001vW-HQ
	for linux-wireless@vger.kernel.org; Mon, 28 Jan 2013 13:49:40 +0100
Message-ID: <1359377405.8120.16.camel@jlt4.sipsolutions.net> (sfid-20130128_134946_582951_56A31DED)
Subject: Re: [PATCH 0/37] iwlwifi: add the MVM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 28 Jan 2013 13:50:05 +0100
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103728_069407_001EDD61)
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130128_103728_069407_001EDD61)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Question for the list ...

Internally, we've identified patches to this new driver as

"iwlwifi (MVM):"

rather than just "iwlwifi:"

We can continue doing so (and would probably also tag patches with
"iwlwifi" for core and "iwlwifi (DVM)" for the DVM part.

Would "iwlmvm"/"iwldvm"/"iwlwifi" make more sense as that's the module
names? It's harder to filter though, I guess.

Thoughts?

johannes

