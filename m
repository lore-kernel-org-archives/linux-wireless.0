Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59865 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGKXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:23:43 -0500
Received: by iwn41 with SMTP id 41so2751380iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Nov 2010 02:23:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <878w15zb8m.fsf@purkki.adurom.net>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
 <1288822429-24541-3-git-send-email-notasas@gmail.com> <AANLkTimfXO9r=DTW3CAiVswmsoKES2qxEiYz4JBOTGu_@mail.gmail.com>
 <AANLkTik0tawXfer2DMSKFXZwFbjYWLoG3nRBYMAMO8WL@mail.gmail.com>
 <AANLkTimtryH0HTWk0ymK6EY1XcCPv6eLDYM-GzuJxhEy@mail.gmail.com> <878w15zb8m.fsf@purkki.adurom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 7 Nov 2010 12:23:22 +0200
Message-ID: <AANLkTinO_VY4gFjP4JHaJtyAwhhTa+9CW74Tz7O=CFDF@mail.gmail.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
To: Kalle Valo <kvalo@adurom.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 7, 2010 at 12:20 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Maybe a comment stating the reason for the callback would make it more
> clear?

Definitely.

>
> --
> Kalle Valo
>
