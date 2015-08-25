Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49190 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHYQNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 12:13:12 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
Date: Tue, 25 Aug 2015 09:13:01 -0700
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>,
	=?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Message-Id: <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org> (sfid-20150825_181315_436337_ACE1EFCB)
References: <1440462512.2670.83.camel@perches.com> <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
To: =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joao Paulo,

> When switching the state of all RFKill switches of type all we need to
> replicate the RFKILL_TYPE_ALL global state to all the other types global
> state, so it is used to initialize persistent RFKill switches on
> register.
> 
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
> ---
> net/rfkill/core.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

