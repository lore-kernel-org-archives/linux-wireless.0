Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37037 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0K2VyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 16:54:09 -0500
Received: by iwn5 with SMTP id 5so625517iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 13:54:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290946620.3467.6.camel@jlt3.sipsolutions.net>
References: <1290945916-95814-1-git-send-email-nbd@openwrt.org> <1290946620.3467.6.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 29 Nov 2010 13:53:48 -0800
Message-ID: <AANLkTi=K7vA2M4RBaV2pLrYdOPYbMTUbFts0HNTkKmup@mail.gmail.com>
Subject: Re: [PATCH] compat: use LED blinking HW offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 28, 2010 at 4:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Felix's patch backported my software blink emulation,
> but if the kernel is 2.6.25 or newer we can also try
> the HW offload first.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks! Applied and pushed,

 Luis
