Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64626 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZH0VDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:03:06 -0400
Received: by iwn42 with SMTP id 42so736857iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 14:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251406807-31495-12-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
	<1251406807-31495-12-git-send-email-luciano.coelho@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 14:02:48 -0700
Message-ID: <43e72e890908271402p2137ce3n4b7459f4ce5fba14@mail.gmail.com>
Subject: Re: [PATCH 11/13] wl1271: use workqueue provided by mac80211 instead
	of the default
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	juuso.oikarinen@nokia.com, kalle.valo@nokia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 2:00 PM, Luciano Coelho<luciano.coelho@nokia.com> wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>
> Use the workqueue provided by the mac80211 stack instead of the system
> default queue.

You mean ieee80211_queue_work() ? This patch seems to be based on an
old wireless-testing.

  Luis
