Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51885 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab2GFVMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:12:50 -0400
Received: by wgbdr13 with SMTP id dr13so9661926wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 14:12:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH v2] mac80211: reduce IEEE80211_TX_MAX_RATES from 5 to 4 to enable upcoming TPC support
Date: Fri, 6 Jul 2012 23:09:41 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, nbd@openwrt.org
References: <1341251176-31113-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1341251176-31113-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201207062309.41859.chunkeey@googlemail.com> (sfid-20120706_231314_846665_09BBAA43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 02, 2012 07:46:16 PM Thomas Huehn wrote:
> IEEE80211_TX_MAX_RATES are reduced from 5 to 4, as there
> is no current hardware supporting a rate chain with 5 multi
> rate stages (mrr), so 4 mrr stages are sufficient. The
> memory that is freed within the ieee80211_tx_info struct will
> be used to implement the upcoming Transmission Power Control
> (TPC). This patch is a pre-requisite to TPC.
> 
> Suggested-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
Tested-by: Christian Lamparter <chunkeey@googlemail.com>

Sorry for the long "pause". But your mail unfortunately got
*redirected* through the spam bin.

Anyway, I've just tested p54(usb) and carl9170 with your patch
applied. So far, everything seems to be fine.

Regards,
	Christian
