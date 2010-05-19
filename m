Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48370 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0ESSMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:12:30 -0400
Received: by fxm10 with SMTP id 10so2661839fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:12:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274282769-19244-7-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
	 <1274282769-19244-7-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 20:12:27 +0200
Message-ID: <AANLkTimDYFG37qiEVMrfEpNoAXIiS3uJHnib7Vnf33Gg@mail.gmail.com>
Subject: Re: [PATCH 6/7] rt2x00: Sync rt2800 MCU boot signal with Ralink
	driver.
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
> Latest versions of the Ralink rt2800 family drivers use 0 as the token value,
> not 0xff.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
