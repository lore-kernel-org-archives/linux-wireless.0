Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40180 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0EIJJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:09:04 -0400
Received: by bwz19 with SMTP id 19so1240790bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273354826-4335-5-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-5-git-send-email-gwingerde@gmail.com>
Date: Sun, 9 May 2010 11:09:03 +0200
Message-ID: <AANLkTikgBvg2Br9iaJPmlCzbfqW48SV68RyjbIeXkLzc@mail.gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Factor out TXWI writing to common rt2800
	code.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> TXWI writing is exactly the same for rt2800pci and rt2800usb, so
> make it common code.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
