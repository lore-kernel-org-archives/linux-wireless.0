Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33404 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbcGSSHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:07:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org,
	Michal Marek <mmarek@suse.com>, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 05/11] Kbuild: don't add obj tree in additional includes
References: <20160615154553.3177021-1-arnd@arndb.de>
	<21521763.EfAflxWUP8@wuerfel> <87a8hdae9j.fsf@purkki.adurom.net>
	<3906958.MrNt71DzrU@wuerfel>
Date: Tue, 19 Jul 2016 21:07:42 +0300
In-Reply-To: <3906958.MrNt71DzrU@wuerfel> (Arnd Bergmann's message of "Tue, 19
	Jul 2016 17:38:51 +0200")
Message-ID: <8760s1v6vl.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_200812_019360_9868E5D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

>> > I think that's fine, a couple were already picked up, and what I have
>> > left now is
>> >
>> > a281bfa5713a [SUBMITTED 20160615] [EXPERIMENTAL] Kbuild: enable -Wmissing-include-dirs by default
>> > 83934921e68e [SUBMITTED 20160615] rtlwifi: don't add include path for rtl8188ee
>> 
>> Apparently[1] you didn't CC linux-wireless and that's why I didn't see
>> the rtlwifi patch in wireless patchwork. Care to resend?
>> 
>> [1] https://patchwork.kernel.org/patch/9178861/
>> 
>
> Done.

Thanks.

> I've also thrown in two patches for drivers/staging/rtl8*/ that I
> submitted a while ago, but I'm not sure if they should get merged
> through the staging tree or the wireless tree. I had previously
> submitted those two as a combined patch along with a third one that
> turned out to be unnecessary.

Greg applies drivers/staging patches to his staging tree, but I'll take
the rtlwifi patch.

-- 
Kalle Valo
