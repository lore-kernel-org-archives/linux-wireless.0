Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45066 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1GDOlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 10:41:55 -0400
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 7/8] ath5k: disable 32KHz sleep clock operation
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
	<1309758467-1712-6-git-send-email-nbd@openwrt.org>
	<1309758467-1712-7-git-send-email-nbd@openwrt.org>
	<CAFtRNNyPJOtjW8vDnjveqmMD3snt_iaDV45p3QZEOKrSyED3yg@mail.gmail.com>
	<4E1190FF.9010701@openwrt.org>
	<CAFtRNNyyx2e3YhKgGwG4h678dEKkQwdVf8pXBtWqYHZzx9r0cQ@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 04 Jul 2011 17:41:49 +0300
In-Reply-To: <CAFtRNNyyx2e3YhKgGwG4h678dEKkQwdVf8pXBtWqYHZzx9r0cQ@mail.gmail.com> (Nick Kossifidis's message of "Mon\, 4 Jul 2011 13\:14\:43 +0300")
Message-ID: <87ipriyuoi.fsf@purkki.adurom.net> (sfid-20110704_164158_660990_837DA7D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis <mickflemm@gmail.com> writes:

> O.K. let's comment it out then and add some information that it's
> disabled by default on available HALs...

Leaving dead code lying around is bad. Why not add a comment with some
pointers how to get the old code if someone wants to do that? For
example git commit id is a good reference and I'm sure it will work
even after 10 years.

-- 
Kalle Valo
