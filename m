Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58993 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab3EAAGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 20:06:12 -0400
Received: by mail-wi0-f177.google.com with SMTP id hi8so1112005wib.16
        for <linux-wireless@vger.kernel.org>; Tue, 30 Apr 2013 17:06:10 -0700 (PDT)
Message-ID: <51805C6F.2070003@gmail.com> (sfid-20130501_020618_690981_731E5060)
Date: Wed, 01 May 2013 01:06:07 +0100
From: Nick Kossifidis <mickflemm@gmail.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: Announcement: AR5513 HAL
References: <CAJ-Vmon50nyvxJyV1J9XTqNDOb1+EbneqkxdkX7H=Nks+JJy+w@mail.gmail.com>
In-Reply-To: <CAJ-Vmon50nyvxJyV1J9XTqNDOb1+EbneqkxdkX7H=Nks+JJy+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 30 Apr 2013 07:02:22 PM BST, Adrian Chadd wrote:
> Hi,
>
> I've just pushed a copy of the AR5513 HAL from Qualcomm Atheros into
> the QCA github repository.
>
> https://github.com/qca/qca-ar5513-hal
>
> The AR5513 is a 2-antenna MIMO 11abg (not 11n) device that was sold
> into a few markets. As far as I'm aware, it's the only legacy PCI(e)
> chipset which the open source Atheros drivers are missing support for.
>
> The HAL is from an earlier development effort, before things had fully
> migrated to using a Madwifi derivative. Thus, the HAL API isn't
> (easily) compatible with the Madwifi or FreeBSD Atheros driver code.
> However, it should be sufficient to bring up chipset support for the
> AR5513 in ath5k.
>
> We've opened this up in the hope that the opensource crowd will add
> support to ath5k for this chipset.
>
> Thanks,
>
>
>
> Adrian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

That's great news !
Thanks a lot Adrian ;-)

I'll try and get one of these devices to play with...
