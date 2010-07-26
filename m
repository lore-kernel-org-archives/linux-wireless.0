Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53819 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0GZQeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 12:34:13 -0400
Received: by fxm14 with SMTP id 14so217139fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 09:34:12 -0700 (PDT)
Subject: Re: [PATCH] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
In-Reply-To: <20100528100901.14580.1322.stgit@fate.lan>
References: <20100528100901.14580.1322.stgit@fate.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 19:34:04 +0300
Message-ID: <1280162044.3492.14.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just want to summarize and finally put that problem to rest.

Was the patch that removes & sets on CONFIG_PCIEASPM? accepted?

Is it possible to check that all ath5k pcie devices that must not use
L0s actually have the 'PCI_EXP_DEVCAP_RBER' disabled (this bit causes
pcie device be marked as legacy, and ASPM is disabled on it)

Best regards,
Maxim Levitsky

