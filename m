Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f175.google.com ([209.85.216.175]:57016 "EHLO
	mail-px0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0CEViv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 16:38:51 -0500
Received: by pxi5 with SMTP id 5so1327216pxi.21
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 13:38:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100305205825.2631.44019.stgit@mj.roinet.com>
References: <20100305205825.2631.44019.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 5 Mar 2010 13:38:31 -0800
Message-ID: <43e72e891003051338v4a97f45di2fdd46b0bfa783b8@mail.gmail.com>
Subject: Re: [PATCH] compat: define KEY_RFKILL, which appeared in Linux 2.6.33
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 5, 2010 at 12:58 PM, Pavel Roskin <proski@gnu.org> wrote:
> It is used in net/rfkill/input.c
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks, applied to the 2.6.33.y branch as well.

  Luis
