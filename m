Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39604 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaKUKeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 05:34:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21615.5541.120044.376524@gargle.gargle.HOWL> (sfid-20141121_113450_164567_459ECA17)
Date: Fri, 21 Nov 2014 16:06:21 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: Fix shared WEP
In-Reply-To: <CA+BoTQm_X3-kpJanZu=dJ3LDPqjAfnUoyBwqzgYGX3bK+H1f2g@mail.gmail.com>
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
	<CA+BoTQnyf0tvg8ngLqsoux-A9-3J46cDuJdd-V=kS24wWS4Y1A@mail.gmail.com>
	<21615.3019.437408.992893@gargle.gargle.HOWL>
	<CA+BoTQm_X3-kpJanZu=dJ3LDPqjAfnUoyBwqzgYGX3bK+H1f2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> Good point, but what I'm worried it'll be easier to miss this subtlety
> and introduce races in the future.

I am not very familiar with ath10k locking, but peer_keys is
also used in ath10k_clear_peer_keys(), where it relies on conf_mutex.
Should that be addressed too ?

> Do you have it saved somewhere? If so, can you post it, please?

http://pastebin.com/yywiPZXL

Sujith
