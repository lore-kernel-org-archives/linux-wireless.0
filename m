Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63099 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0EIJKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:10:14 -0400
Received: by bwz19 with SMTP id 19so1241087bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:10:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273354826-4335-6-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-6-git-send-email-gwingerde@gmail.com>
Date: Sun, 9 May 2010 11:10:12 +0200
Message-ID: <AANLkTilo9epmkDp__KxBVHv7BO3XQkR-knmiinKGlmgS@mail.gmail.com>
Subject: Re: [PATCH 5/9] rt2x00: Factor out RXWI processing to common rt2800
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
> RXWI processing is exactly the same for rt2800pci and rt2800usb, so
> make it common code.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
