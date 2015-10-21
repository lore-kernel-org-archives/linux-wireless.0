Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbbJUBJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 21:09:29 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 04/16] rtl8xxxu: Skip disabled efuse words early
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-5-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 21:09:27 -0400
In-Reply-To: <1445323546-12807-5-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:34 +0200")
Message-ID: <wrfjr3kpvxh4.fsf@redhat.com> (sfid-20151021_030931_580392_EC554F53)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Avoid a negative conditional and an extra level of indentation in the
> bigger part of the loop body.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 28 +++++++++++-------------
>  1 file changed, 13 insertions(+), 15 deletions(-)

Nice cleanup - applied.

Jes
