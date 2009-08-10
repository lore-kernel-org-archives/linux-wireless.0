Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:52928 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZHJWvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:51:13 -0400
Received: by pzk34 with SMTP id 34so3120470pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 10 Aug 2009 15:50:54 -0700
Message-ID: <43e72e890908101550u32333415hdcf60dbc81ff70e7@mail.gmail.com>
Subject: Re: [PATCH 1/7] [compat-2.6] Rename the rest of CONFIG_MAC80211_MESH
	to CONFIG_COMPAT_MAC80211_MESH
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 8, 2009 at 5:38 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> Without this, some symbols can not be resolved because only parts of mesh were disabled.

Thanks a lot! I applied this and the rest of the patches, except for
the few I noted (tuple, usb compat removal).

  Luis
