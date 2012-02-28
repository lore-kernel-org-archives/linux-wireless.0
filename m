Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51081 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169Ab2B1BZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:25:58 -0500
Received: by mail-iy0-f174.google.com with SMTP id j37so528683iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 17:25:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330353346-62125-1-git-send-email-nbd@openwrt.org>
References: <1330353346-62125-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 27 Feb 2012 17:25:37 -0800
Message-ID: <CAB=NE6VhqJOrSxt5_1uY6AniP5Z-U7eks-Qtx3NgDz=t5pD2eg@mail.gmail.com> (sfid-20120228_022612_544281_E5C67074)
Subject: Re: [PATCH] compat-wireless: use portable #! for bash scripts
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 6:35 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Some systems (e.g. FreeBSD) do not have bash in /bin
> Based on a patch by Jo-Philipp Wich
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks applied and pushed.

 Luis
