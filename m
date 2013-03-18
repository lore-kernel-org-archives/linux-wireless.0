Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3CRSzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 14:55:55 -0400
Message-ID: <1363632949.8260.2.camel@jlt4.sipsolutions.net> (sfid-20130318_195558_806367_FB23EFC4)
Subject: Re: [PATCH] iwlwifi: remove 5ghz_disable option
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Mon, 18 Mar 2013 19:55:49 +0100
In-Reply-To: <1363106158-31904-1-git-send-email-sgruszka@redhat.com> (sfid-20130312_173535_577986_9F870BB6)
References: <1363106158-31904-1-git-send-email-sgruszka@redhat.com>
	 (sfid-20130312_173535_577986_9F870BB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-12 at 17:35 +0100, Stanislaw Gruszka wrote:
> 5ghz_disable has no effect any longer, that was changed during
> refactoring of EEPROM reading/parsing. Remove it, wpa_supplicant
> allow now to specify frequencies, on which device will operate.

Applied, thanks.

johannes

