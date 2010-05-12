Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64653 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0ELHMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:12:08 -0400
Received: by fxm4 with SMTP id 4so234048fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-8-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-8-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:12:05 +0200
Message-ID: <AANLkTikNRG9q8C8D8E2pZ5bRcIB86SCP8K1kcYAbXj4f@mail.gmail.com>
Subject: Re: [PATCH 7/9] rt2x00: In debugfs frame dumping allow the TX
	descriptor to be part of the skb.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Preparation for futher cleanups in the area of properly maintaining the skb
> data without fiddling with the skb->data pointer.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
