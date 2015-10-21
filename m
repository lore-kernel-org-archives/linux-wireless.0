Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbbJUCDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 22:03:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 14/16] rtl8xxxu: Introduce a device agnostic constant for efuse map length
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-15-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 22:03:10 -0400
In-Reply-To: <1445323546-12807-15-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:44 +0200")
Message-ID: <wrfjy4exugf5.fsf@redhat.com> (sfid-20151021_040314_216778_F0BF99F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Preparatory step for adding support for RTL8188EU devices.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>
> Notes:
>     An alternative approach to keeping a buffer that is big enough to hold
>     the efuse map of any of the supported chips would be to allocate the
>     efuse map on-the-go to pass it between read_efuse() and parse_efuse().
>     
>     This would also reduce the memory footprint of struct rtl8xxxu_priv.
>
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 5 ++++-
>  2 files changed, 6 insertions(+), 3 deletions(-)

This change is already handled by my current code.

Jes
