Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:44796 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3FFDmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 23:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <1370488216-11626-1-git-send-email-sujith@msujith.org>
References: <1370488216-11626-1-git-send-email-sujith@msujith.org>
Date: Thu, 6 Jun 2013 12:42:51 +0900
Message-ID: <CA+55aFwUTbCPh18z9otEG-SAfBV_t6hYOpa_u_mnccSLWAvmfw@mail.gmail.com> (sfid-20130606_054256_166150_86682D43)
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 6, 2013 at 12:10 PM, Sujith Manoharan <sujith@msujith.org> wrote:
>
> Change the default to minstrel which is more robust in such cases.

Ack. Background for John: the renaming means that people who had the
old broken default won't just silently continue to see their "default
y" from their old defconfigs.

So now you have to explicitly enable this by hand to get the fragile
legacy rate control.

            Linus
