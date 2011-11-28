Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61364 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1K1NvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 08:51:01 -0500
Received: by qadc14 with SMTP id c14so1135372qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 05:51:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321781962-92285-1-git-send-email-nbd@openwrt.org>
References: <1321781962-92285-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 08:50:40 -0500
Message-ID: <CAB=NE6X41Y910k9BuUQ_WRxy2KdLVaoVPM4yUc9urnf=6w-O8g@mail.gmail.com> (sfid-20111128_145106_970860_9F04ECEC)
Subject: Re: [PATCH] compat: fix misplaced #ifdef for the workqueue backport
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 20, 2011 at 4:39 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied and pushed! Also pushed onto the linux-3.2.y branch
and will make a new stable release with this based on 3.2.

  Luis
