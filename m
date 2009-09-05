Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:59837 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZIETdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 15:33:52 -0400
Received: by iwn5 with SMTP id 5so531776iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 12:33:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA270AF.2010902@gmx.de>
References: <4AA270AF.2010902@gmx.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 5 Sep 2009 12:33:34 -0700
Message-ID: <43e72e890909051233s3df12787oa1c59a8b9728c271@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath,ar9170: move CTL_ defines into regd.h
To: Joerg Albert <jal2@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 5, 2009 at 7:07 AM, Joerg Albert<jal2@gmx.de> wrote:
> The ar9170 driver needs the defines for conformance test limit groups
> and cannot include regd_common.h
>
> Signed-off-by: Joerg Albert <jal2@gmx.de>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Just please test compilation of ath5k and ath9k as well.

  Luis
