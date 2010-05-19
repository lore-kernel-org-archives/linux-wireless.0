Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0ESSK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:10:26 -0400
Received: by fxm10 with SMTP id 10so2659509fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274282769-19244-3-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
	 <1274282769-19244-3-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 20:10:15 +0200
Message-ID: <AANLkTiktN6_0F5IBR8XStKUh7qfnFEn97ZkhuIwnPO4T@mail.gmail.com>
Subject: Re: [PATCH 2/7] rt2x00: Move all register definitions for rt2800 to
	rt2800.h.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 5:26 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> There is no point on having them separated across 3 files.
> At the same time rename USB_CYC_CFG to its proper name US_CYC_CNT
> (as per the datasheet).
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
