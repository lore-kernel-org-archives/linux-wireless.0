Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2BQX6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 18:58:24 -0500
Received: by iacb35 with SMTP id b35so5043340iac.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 15:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329472141-28781-1-git-send-email-coelho@ti.com>
References: <1329472141-28781-1-git-send-email-coelho@ti.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Feb 2012 15:58:04 -0800
Message-ID: <CAB=NE6U0brv=BQwB+KLZt0gO7g9FJTxLKymve4BxhnJ6hi0KWg@mail.gmail.com> (sfid-20120218_005838_962049_A04E26E8)
Subject: Re: [PATCH 1/2] compat-wireless: update bluetooth patch to latest wireless-testing
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2012 at 1:49 AM, Luciano Coelho <coelho@ti.com> wrote:
> There is a small change in the bt_sock_unregister() function in
> af_bluetooth (an extra if) that cause the patch not to apply anymore.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Applied and pushed, thanks!

  Luis
