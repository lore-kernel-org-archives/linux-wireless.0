Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64935 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2BXAKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 19:10:30 -0500
Received: by iacb35 with SMTP id b35so2255746iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 16:10:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329666592-19702-1-git-send-email-sidhayn@gmail.com>
References: <1329666592-19702-1-git-send-email-sidhayn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Feb 2012 16:10:09 -0800
Message-ID: <CAB=NE6V=Nz1AVmU2x3d2urYKyiYjCM8MCxQ8FkGFHj1VGk6z4w@mail.gmail.com> (sfid-20120224_011034_222669_CADD2918)
Subject: Re: [PATCH] [compat-wireless] cleanup modprobe calls
To: Rick Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2012 at 7:49 AM, Rick Farina <sidhayn@gmail.com> wrote:
> There are a lot of needless calls to "modprobe -l <drivername>"
> None of this is needed, and it errors when modprobe -l is removed
> (such as when KMOD replaces modutils). Since modprobe -l is already
> legacy, let's just remove it.
>
> Signed-off-by: Rick Farina <sidhayn@gmail.com>

Thanks, applied!

  Luis
