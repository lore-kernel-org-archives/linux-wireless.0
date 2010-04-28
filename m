Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41773 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0D1XXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 19:23:14 -0400
Received: by pxi17 with SMTP id 17so2993690pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 16:23:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272496482-12687-1-git-send-email-linville@tuxdriver.com>
References: <1272496482-12687-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 28 Apr 2010 16:22:53 -0700
Message-ID: <o2o43e72e891004281622lea58777bjf054e8cc36929e07@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: fix tx status reporting
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 28, 2010 at 4:14 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> When reporting Tx status, indicate that only one rate was used.
> Otherwise, the rate is frozen at rate index 0 (i.e. 1Mb/s).
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Stable fix?

  The stable whore, Luis
