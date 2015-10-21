Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbbJUBwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 21:52:07 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 06/16] rtl8xxxu: rtl8723au: Introduce a pointer to efuse
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-7-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 21:52:05 -0400
In-Reply-To: <1445323546-12807-7-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:36 +0200")
Message-ID: <wrfjfv15vvi2.fsf@redhat.com> (sfid-20151021_035214_521517_5DA01D20)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 26 +++++++++++++-----------
>  1 file changed, 14 insertions(+), 12 deletions(-)

This cleans up the code nicely - so I applied both of these.

Jes
