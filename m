Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51196 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZHNArs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:47:48 -0400
Received: by yxe5 with SMTP id 5so1495553yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 17:47:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 17:47:29 -0700
Message-ID: <43e72e890908131747x13c5464dm550985f856f8c0d2@mail.gmail.com>
Subject: Re: [PATCH v2 00/25] wireless: cleanup and reorganize kconfig
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 5:42 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> At first I had each group with an appended
> "wireless drivers support" but in the end that seemed too
> odd so I removed it and now group drivers are pivoted by
> the vendor driver.

vendor name I meant.

  L
