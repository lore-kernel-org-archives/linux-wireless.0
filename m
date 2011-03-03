Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52364 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CCKwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 05:52:21 -0500
Received: by qyk7 with SMTP id 7so5112095qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 02:52:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299149205-21439-1-git-send-email-juhosg@openwrt.org>
References: <1299149205-21439-1-git-send-email-juhosg@openwrt.org>
Date: Thu, 3 Mar 2011 11:52:21 +0100
Message-ID: <AANLkTi=+4KXRo7hW=b458nGADMtv_Aq+2C-gEuFUT0Z6@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: fix whitespace damage in the rt2800 specific code
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 3, 2011 at 11:46 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The rt2800 specific code contains a lots of whitespace damage caused by
> the commit 'rt2x00: Add support for RT5390 chip'.
>
> This patch fixes those whitespace errors.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
