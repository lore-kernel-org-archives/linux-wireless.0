Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65525 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0FMUzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 16:55:25 -0400
Received: by pvg16 with SMTP id 16so2329924pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 13:55:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim4kDJZnEdNy-C4xhOigWiTWQZhVJAs36LOUbjQ@mail.gmail.com>
References: <AANLkTim4kDJZnEdNy-C4xhOigWiTWQZhVJAs36LOUbjQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 13 Jun 2010 13:55:03 -0700
Message-ID: <AANLkTimxtFMpJftSdwDK_DRap4Bw0iVPS9Tcwe_vE_f9@mail.gmail.com>
Subject: Re: wireless button problem with atheros on hp machines
To: Leonardo <sombriks@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 13, 2010 at 1:49 PM, Leonardo <sombriks@gmail.com> wrote:
> hello all, i don't know if this is the correct channel to report, but
> from Slackware 13.0 (2.6.29.6) to 13.1 (2.6.33.4) the wireless button
> stopped to work properly.

Try 2.6.30, 2.6.31, and 2.6.32 and see if you see the issue on one of
those. If so then you can use git bisect to find the culprit. I
realize this can be quite cumbersome, but without more information I'm
afraid this is as good as it gets. Instead of using Linus' tree you'll
want to use the linux-2.6-allstable.git tree since that will have the
extra version kernel revisions.

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

  Luis
