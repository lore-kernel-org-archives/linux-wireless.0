Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37788 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1KPI11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 03:27:27 -0500
Received: by yenq3 with SMTP id q3so1653633yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 00:27:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw56rVGCJfx+7niRJ0whUk3c1H8o228dkOTcoi5agXZF_A@mail.gmail.com>
References: <1321371888-26897-1-git-send-email-patrick.kelle81@gmail.com>
	<CAA93jw7nWHnCnT48RJ00+Zxq9CFuCzhkeh=+7h+DqvYH2T7W1Q@mail.gmail.com>
	<1321384334.3975.2.camel@jlt3.sipsolutions.net>
	<CAA93jw56rVGCJfx+7niRJ0whUk3c1H8o228dkOTcoi5agXZF_A@mail.gmail.com>
Date: Wed, 16 Nov 2011 09:27:26 +0100
Message-ID: <CAGXE3d8orQLS4prLhV9rhANZszry0-FAOPHygukZ2mdBa3Tn0g@mail.gmail.com> (sfid-20111116_092730_752772_C85805CB)
Subject: Re: [PATCH] minstrel_ht: Remove unused function parameters
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Patrick Kelle <patrick.kelle81@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2011 at 8:29 PM, Dave Taht <dave.taht@gmail.com> wrote:
> what was the intent of parameter being removed in this patch series,
> originally, then?

Removing _unused_ function parameters from internal minstrel_ht functions
looks like a useful cleanup to me :) and might even help the compiler to
generate better code ...

Helmut
