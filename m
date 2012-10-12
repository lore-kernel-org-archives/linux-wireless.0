Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45054 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab2JLH2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 03:28:43 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so2584352obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 00:28:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5077BE43.7050200@gmail.com>
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<20121011203112.GB3317@kroah.com>
	<5077BE43.7050200@gmail.com>
Date: Fri, 12 Oct 2012 12:58:42 +0530
Message-ID: <CAD2nsn0UgUdKk3mRHZUcwFstNS3PhwDKSN8R8Sr05VzPYzv=qg@mail.gmail.com> (sfid-20121012_092846_488891_CA48C4F0)
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pontus,

On Fri, Oct 12, 2012 at 12:22 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> Hi,
>
>
>> But what is keeping this driver from going to the "proper" place in the
>> kernel tree (i.e. drivers/net/...)?  I don't have a problem adding it to
>> the staging tree, but it would need a TODO file to list what is needed
>> to get it out of the staging tree.
>
>
> I couldn't decide myself so I asked John and he suggested staging. Perhaps
> it should be in driver/net/wireless after all. Can you and John give some
> advice?
>
> Here's a list of things to consider:
>
> * The FW API is reverse engineered and no real documentation is available.
> * Limited functionality (notably no HW crypto offload).
> * I'm committed to maintaining the driver and fix problems, but only as a
> hobbist.
> * It has received very limited testing. S L-H is the only one except myself
> that has run it.

was just checking out..
http://wireless.kernel.org/en/users/Drivers/ar5523
may be you can update everything there :)

>
> Cheers,
>
> Pontus
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
