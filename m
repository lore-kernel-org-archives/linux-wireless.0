Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0EMTak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:30:40 -0400
Received: by fxm6 with SMTP id 6so752896fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 12:30:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273778166-3833-3-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
	 <1273778166-3833-3-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 21:30:39 +0200
Message-ID: <AANLkTinMokg_RxT6y7NGmdh784nY2-bQbRSS9FwWezZT@mail.gmail.com>
Subject: Re: [PATCH 2/4] rt2x00: Fix rt2800usb TX descriptor writing.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 9:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The recent changes to skb handling introduced a bug in the rt2800usb
> TX descriptor writing whereby the length of the USB packet wasn't
> calculated correctly.
> Found via code inspection, as the devices themselves didn't seem to mind.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
