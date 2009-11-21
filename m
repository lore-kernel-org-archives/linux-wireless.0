Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42348 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZKUCUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 21:20:30 -0500
Received: by iwn8 with SMTP id 8so2973817iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 18:20:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
References: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 20 Nov 2009 18:20:16 -0800
Message-ID: <43e72e890911201820m7504fc43ldbde4ea47f109485@mail.gmail.com>
Subject: Re: [PATCH 0/3] [compat-2.6] Small fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2009 at 2:01 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Fix build of compat-wireless and refresh some files.
>
> compat-wireless does not build with kernel 2.6.26 and older, because
> debugfs_remove_recursive is missing. This is not fixed by this patch.
>
> Hauke Mehrtens (3):
>  [compat-2.6] Add IFF_DONT_BRIDGE definition to compat
>  [compat-2.6] Refresh config.mk
>  [compat-2.6] Refresh patches

thanks applied.

  Luis
