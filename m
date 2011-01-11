Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61073 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1AKRdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 12:33:14 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimDHO=oiR3ncX4BLmMJaoUAmaQL6r=bZcWV4-Gg@mail.gmail.com>
References: <alpine.LNX.2.00.1101110044580.32164@swampdragon.chaosbits.net>
	<AANLkTimDHO=oiR3ncX4BLmMJaoUAmaQL6r=bZcWV4-Gg@mail.gmail.com>
Date: Tue, 11 Jan 2011 19:33:13 +0200
Message-ID: <AANLkTinEbfAsMiFaoC_XBTDOD7pOoUeTBXjXfiiOKof7@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Don't leak mem in error path of rt2x00lib_request_firmware()
From: Pekka Enberg <penberg@kernel.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 7:30 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> We need to release_firmware() in order not to leak memory.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>
> I can assume that release_firmware() checks if 'fw' is null?

Yes, it does.

> If so:
>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
