Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38702 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab1KQOq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 09:46:28 -0500
MIME-Version: 1.0
In-Reply-To: <1321481775-10853-1-git-send-email-gwingerde@gmail.com>
References: <1321481775-10853-1-git-send-email-gwingerde@gmail.com>
Date: Thu, 17 Nov 2011 15:46:28 +0100
Message-ID: <CAGXE3d80tV9X9xuRvwg_KC6GksBU4DcLp5FeWRUNaTCDH2YHPg@mail.gmail.com> (sfid-20111117_154632_703275_C7E904AD)
Subject: Re: [PATCH] rt2x00: Fix efuse EEPROM reading on PPC32.
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Fix __le32 to __le16 conversion of the first word of an 8-word block
> of EEPROM read via the efuse method.
>
> Reported-and-tested-by: Ingvar Hagelund <ingvar@redpill-linpro.com>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: <stable@vger.kernel.org>

Nice catch!

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
