Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0EMJq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:46:56 -0400
Received: by fxm6 with SMTP id 6so111466fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 02:46:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273743418-28383-9-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
	 <1273743418-28383-9-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 11:46:55 +0200
Message-ID: <AANLkTinsE3dE7QInbzji3b7FvooTdN_QC5IM7H4vwpa8@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] rt2x00: Push beacon TX descriptor writing to
	drivers.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 11:36 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Not all the devices require a TX descriptor to be written (i.e. rt2800
> device don't require them). Push down the creation of the TX descriptor
> to the device drivers so that they can decide for themselves whether
> a TX descriptor is to be created.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
