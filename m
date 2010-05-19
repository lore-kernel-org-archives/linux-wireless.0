Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:48991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0ESSJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:09:26 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1728252fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:09:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274282769-19244-2-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
	 <1274282769-19244-2-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 20:09:24 +0200
Message-ID: <AANLkTik2x8J5_BTG59Pqi8UDPiygog6no4NtSfji7-6h@mail.gmail.com>
Subject: Re: [PATCH 1/7] rt2x00: Remove RT2870 chipset identification.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 5:26 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> There is no evidence, either in adapters or in the Ralink code, that such
> a device actually exists. All so-call RT2870 adapter identify themselves
> as RT2860.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
