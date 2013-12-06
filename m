Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64005 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3LFKkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 05:40:21 -0500
Received: by mail-ob0-f176.google.com with SMTP id va2so541244obc.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 02:40:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386167786.19448.4.camel@dcbw.foobar.com>
References: <20131203202607.0b445195@kemnade.info> <1386167786.19448.4.camel@dcbw.foobar.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Fri, 6 Dec 2013 13:40:00 +0300
Message-ID: <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com> (sfid-20131206_114025_141793_E17CB525)
Subject: Re: status of libertas_tf + sdio?
To: Dan Williams <dcbw@redhat.com>
Cc: Andreas Kemnade <andreas@kemnade.info>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Out of curiosity,

Does anyone know if it's possible to get thin firmware for 8686 with
SPI interface?

Regards
Vasily

On Wed, Dec 4, 2013 at 5:36 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2013-12-03 at 20:26 +0100, Andreas Kemnade wrote:
>> Hi,
>>
>> I want to be able to use my marvel sdio wifi as an ap, so I am interested
>> in having the sdio interface of libertas_tf. I sucessfully copied
>> over the libertas_tf directory from somewhere and fixed a bit of things
>> and compiled that in a 3.7 kernel. It works.
>> But now I am thinking about generating a clean patch.
>>
>> I found this one here:
>> http://www.spinics.net/lists/linux-wireless/msg55245.html
>> Is there any newer patch to start working on?
>
> I don't think so.  If you're interested in working on this, great!
>
> Dan
>
>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
