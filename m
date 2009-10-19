Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42386 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZJSCjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 22:39:05 -0400
Received: by iwn8 with SMTP id 8so2055592iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 19:39:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255813605-19366-1-git-send-email-hauke@hauke-m.de>
References: <1255813605-19366-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 19 Oct 2009 11:38:49 +0900
Message-ID: <43e72e890910181938y45c7ea19p737ff658f4685016@mail.gmail.com>
Subject: Re: [PATCH] [compat-2.6 and compat-2.6-stable] rename ieee80211_rx
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2009 at 6:06 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Rename ieee80211_rx to avoild conflicts with the export done by older
> libipw. libipw in kernel 2.6.32 and older also exports a symbol named
> ieee80211_rx. If libipw from normal kernel and mac80211 from
> compat-wireless is loaded you will get an conflict.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

thanks applied
