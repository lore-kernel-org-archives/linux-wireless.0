Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:50206 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3BYWqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 17:46:51 -0500
Message-ID: <31632788.15939241361832308372.JavaMail.defaultUser@defaultHost> (sfid-20130225_234655_044794_1270B25A)
Date: Mon, 25 Feb 2013 23:45:08 +0100 (CET)
From: Fabio Rossi <rossi.f@inwind.it>
Reply-To: Fabio Rossi <rossi.f@inwind.it>
To: <seth.forshee@canonical.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Ensure off-channel frames don't get queued
Cc: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 Feb 2013 Seth wrote:

>Commit 6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue
>handling during scans) contains a bug that causes off-channel frames to
>get queued when they should be handed down to the driver for transmit.
>Prevent this from happening.
>
>Reported-by: Fabio Rossi <rossi.f@inwind.it>
>Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>---
>
>Fabio, this patch should fix the problem. Can you verify?

tested, now it works again

Fabio
