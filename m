Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:36761 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbZHNClq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 22:41:46 -0400
Received: by yxe5 with SMTP id 5so1561739yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 19:41:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250214676-10608-1-git-send-email-lrodriguez@atheros.com>
References: <1250214676-10608-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 19:41:27 -0700
Message-ID: <43e72e890908131941t66b7eaco233ce687a435ad7d@mail.gmail.com>
Subject: Re: [RFT] ar9170: check mpdu len on single mpdu before processing
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 6:51 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:

> BTW Chris, Stephen points out we *can* use packet mode for
> RX with Otus devices.

This is true but if we have stream mode working it seems best to keep
it I think. Turns out we *do* seem to use it for Windows.

  Luis
