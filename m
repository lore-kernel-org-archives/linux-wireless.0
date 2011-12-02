Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38232 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1LBOwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 09:52:01 -0500
Received: by ggnr5 with SMTP id r5so3012013ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2011 06:51:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322824366-95660-1-git-send-email-nbd@openwrt.org>
References: <1322824366-95660-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 2 Dec 2011 09:43:51 -0500
Message-ID: <CAB=NE6X36hPpUA8Mnaa6C2OYduaTFiZ1TggaDAw1BD8BH2GTaA@mail.gmail.com> (sfid-20111202_155209_927203_4199DEBF)
Subject: Re: [PATCH] compat: fix security_sk_clone dummy backport compile
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 2, 2011 at 6:12 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> linux/security.h needs to be included before the dummy function overrides it,
> otherwise the macro that redirects it to the compat version will apply to
> the kernel function as well, causing multiple conflicting definitions
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, both patch applied and pushed!

  Luis
