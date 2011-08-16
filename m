Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42872 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1HPAPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 20:15:52 -0400
Received: by yie30 with SMTP id 30so3488746yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 17:15:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1f0ede1efd9e5d368352ec258d716fcc.squirrel@mail.errtech.com>
References: <1f0ede1efd9e5d368352ec258d716fcc.squirrel@mail.errtech.com>
Date: Tue, 16 Aug 2011 08:15:51 +0800
Message-ID: <CAJ-VmomLYXDV7gc-7O28G8xEqyN493U=qw8f5k5KVyaOVon8hA@mail.gmail.com> (sfid-20110816_021554_649753_1A6B2CC3)
Subject: Re: AR9271 & Client Mode
From: Adrian Chadd <adrian@freebsd.org>
To: tmail133@kglug.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2011 07:25, chris <tmail133@kglug.org> wrote:
> It was suggested to me that the AR9271 will work without the firmware in
> client mode. Can anybody verify this? I'm looking to get it working with a
> free distribution that does not allow binary-blob, non-free firmware, etc.

I was under the impression (not that I've yet tried any USB Atheros
hardware) that the USB devices require _some_ firmware uploaded to
them before the Linux ath9k_htc code can use it.



Adrian
