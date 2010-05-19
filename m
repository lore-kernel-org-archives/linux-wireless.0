Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52246 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0ESTTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 15:19:32 -0400
Received: by fxm10 with SMTP id 10so2735989fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 12:19:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 21:19:30 +0200
Message-ID: <AANLkTilx_3YeFeeI6Ilwcy1JoBhYEF392k5EWk4UmZcA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] rt2x00: Fix HT40 operation in rt2800.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 9:17 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Closer inspection of the legacy Ralink driver reveals that in case of HT40+
> or HT40- we must adjust the frequency settings that we program to the device.
> Implement the same adjustment in the rt2x00 code.
>
> With this HT40 seems to work for all devices supported by rt2800pci and
> rt2800usb.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
