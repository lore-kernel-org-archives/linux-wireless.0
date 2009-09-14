Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46049 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZINI70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:59:26 -0400
Received: by fxm17 with SMTP id 17so681862fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 01:59:28 -0700 (PDT)
Message-ID: <4AAE05EF.5090105@gmail.com>
Date: Mon, 14 Sep 2009 10:59:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ath5k: allocate ath5k_hw prior to initializing
 hw
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com> 	<1252917123-11559-3-git-send-email-lrodriguez@atheros.com> 	<4AAE0297.20401@gmail.com> <43e72e890909140150i1e060503nae9987aba9275764@mail.gmail.com> 	<43e72e890909140153rd61009ai3eb421e5981a6a43@mail.gmail.com> <43e72e890909140156jcb1f299i718d0b9fe8ab07a8@mail.gmail.com>
In-Reply-To: <43e72e890909140156jcb1f299i718d0b9fe8ab07a8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2009 10:56 AM, Luis R. Rodriguez wrote:
> Yeah looks peachy.

Yeah, I realized it would emit a warning if ath9k_common_ops was const
and ath_common->ops wasn't. This way it is OK. Sorry for the noise.

Anyway making ath9k_common_ops const would be good ;).
