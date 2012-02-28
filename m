Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63782 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965023Ab2B1B2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:28:07 -0500
Received: by iagj37 with SMTP id j37so531038iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 17:28:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330354304-69044-1-git-send-email-nbd@openwrt.org>
References: <1330354304-69044-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 27 Feb 2012 17:27:47 -0800
Message-ID: <CAB=NE6VfewsN3ej8uofp4Uk2Y=y5U+d7g3CKHH8+u47dB+qZyA@mail.gmail.com> (sfid-20120228_022815_604277_ACE40D88)
Subject: Re: [PATCH] compat-wireless: fix directory copying in admin-update.sh
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 6:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On my system the trailing slash leads to the directory contents being copied
> to the target instead of the full directory, which results in breakage during
> build.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

thanks applied and pushed!

  Luis
