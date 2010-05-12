Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0ELHL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:11:29 -0400
Received: by fxm4 with SMTP id 4so233439fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:11:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-5-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-5-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:11:27 +0200
Message-ID: <AANLkTilRVRMFTKDBvwHYB0TK1cVC7JRyPsyDuEm4v-Kw@mail.gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Simplify TXD handling of beacons.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The handling of tx descriptors for beacons can be simplified by updating
> write_tx_desc implementations of each driver to write directly to the
> queue entry descriptor instead of to a provided memory area.
> This is also a preparation for further clean ups where descriptors are
> properly reserved in the skb instead of fiddling with the skb data
> pointer.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
