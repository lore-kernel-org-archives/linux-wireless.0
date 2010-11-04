Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49516 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0KDQhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 12:37:45 -0400
Received: by qwf7 with SMTP id 7so1438327qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 09:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
Date: Thu, 4 Nov 2010 18:37:44 +0200
Message-ID: <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
Subject: Re: [PATCH v4] wl1271: Change wl12xx Files Names
From: Grazvydas Ignotas <notasas@gmail.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Kalle Valo <kvalo@adurom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 5:07 PM, Shahar Levi <shahar_levi@ti.com> wrote:
> All files name prefix removed due to the fact that wl12xx driver supports
> wl1271 and wl1273.
> Also the definition in Kconfig and header files changed respectively.
>
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>

Hmh the name 'wl12xx' kind of implies it covers 1251, while in fact
wl1251 is completely separate driver.. At least the Kconfig help text
should mention it doesn't cover wl1251 and users should use respective
driver for wl1251.
