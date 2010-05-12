Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:38913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0ELSrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 14:47:08 -0400
Received: by fg-out-1718.google.com with SMTP id d23so717053fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 11:47:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-3-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-3-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 20:47:05 +0200
Message-ID: <AANLkTik_8-hSm7MDcHQzsFbinFqvQMc_vDMUbAfMdZDi@mail.gmail.com>
Subject: Re: [PATCH 2/9] rt2x00: Fix beacon descriptor writing for rt61pci.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The buffer address descriptor word is not part of the TXINFO structure
> needed for beacons. The current writing of that word for beacons is
> therefore an out-of-bounds write.
> Fix this by only writing the buffer address descriptor word for TX
> queues.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
