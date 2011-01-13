Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59883 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1AMAqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 19:46:12 -0500
Received: by iyj18 with SMTP id 18so1044561iyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 16:46:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294585234-9806-2-git-send-email-hauke@hauke-m.de>
References: <1294585234-9806-1-git-send-email-hauke@hauke-m.de> <1294585234-9806-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 16:45:51 -0800
Message-ID: <AANLkTi=OOheQzQ98PJ_GUFstJQCcbNhoA17px8DAyWMH@mail.gmail.com>
Subject: Re: [PATCH] compat: backport pci_wake_from_d3
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 9, 2011 at 7:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is needed by atl1c.
>
> This is compat-wireless upstream commit:
>        454fb1a4a698bd2935af76800bc17e14b086476a
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

 Luis
