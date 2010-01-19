Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54793 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0ASTWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:22:55 -0500
Received: by pwj9 with SMTP id 9so2608667pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 11:22:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B547031.60600@openwrt.org>
References: <4B547031.60600@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 19 Jan 2010 11:22:35 -0800
Message-ID: <43e72e891001191122m9813bebn89024b722311c76b@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat: fix firmware class compile on linux 2.6.32
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2010 at 6:29 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> The firmware class API change happened after 2.6.32, so move the compat
> code to the 2.6.33 header file.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied thanks.
