Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40909 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab0JKRm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:42:27 -0400
Received: by ywi6 with SMTP id 6so730377ywi.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 10:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB2F91B.9000702@openwrt.org>
References: <4CB2F91B.9000702@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 11 Oct 2010 10:42:06 -0700
Message-ID: <AANLkTimLWAfmjgSBfAkYmdmHxYiF8uwnMeVKgBM6M-8m@mail.gmail.com>
Subject: Re: [PATCH] compat: fix a crash in the netlink backport
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 11, 2010 at 4:46 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Do not set the .doit wrapper if there is no .doit function.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied.

  Luis
