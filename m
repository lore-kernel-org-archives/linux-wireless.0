Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:44749 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0ESSLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:11:15 -0400
Received: by ewy8 with SMTP id 8so2785121ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:11:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274282769-19244-5-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
	 <1274282769-19244-5-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 20:11:13 +0200
Message-ID: <AANLkTiljEiNQdB_oTVk6G4YtMl4W2dKIGvvmHYqk3vy6@mail.gmail.com>
Subject: Re: [PATCH 4/7] rt2x00: Simplify check for external LNA in
	rt2800_init_rfcsr.
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
> Instead of parsing the EEPROM information, use the flag that was set during
> device initialization.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
