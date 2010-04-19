Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:34682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0DSKHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 06:07:23 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1894800fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 03:07:22 -0700 (PDT)
Message-ID: <4BCC2929.8020404@gmail.com>
Date: Mon, 19 Apr 2010 11:58:01 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb: delete Allwin devices
References: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com> <u2ja32f33a41004160417jfcf1db3bw62d464405fead085@mail.gmail.com> <20100416134326.GD8554@tuxdriver.com> <4BC8D44A.2040903@gmail.com>
In-Reply-To: <4BC8D44A.2040903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2010 11:19 PM, Gertjan van Wingerde wrote:

> And finally, these devices are still mentioned in the Ralink windows driver,
> so we must assume that they actually exist.

some devices in the windows drivers are experimental(never produced/shipped).

> However, the common sense approach may be appropriate, so moving these devices
> to the correct section does seem okay.

done.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
