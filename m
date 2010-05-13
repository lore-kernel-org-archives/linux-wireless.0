Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:15005 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab0EMTc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:32:29 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1288901fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 12:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273778166-3833-5-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
	 <1273778166-3833-5-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 21:32:27 +0200
Message-ID: <AANLkTimWTrLTRtJ-2tMkA0-PrfHktdCSj2ET76lUKN-w@mail.gmail.com>
Subject: Re: [PATCH 4/4] rt2x00: Centralize rt2800 beacon writing.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 9:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The beacon writing functions of rt2800pci and rt2800usb are now identical.
> Move them to rt2800lib to only have one central function.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
