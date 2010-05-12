Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0ELHIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:08:15 -0400
Received: by fxm4 with SMTP id 4so230781fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-10-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-10-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:08:13 +0200
Message-ID: <AANLkTikfpVFt1rFYJ9wtmD7ZnYrhLxAq5kNRI_pWdG_b@mail.gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Properly reserve room for descriptors in
	skbs.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Instead of fiddling with the skb->data pointer and thereby risking
> out of bounds accesses, properly reserve the space needed in an
> skb for descriptors.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
