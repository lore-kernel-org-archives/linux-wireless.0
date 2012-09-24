Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45205 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2IXOqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 10:46:19 -0400
Received: by oago6 with SMTP id o6so5464303oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 07:46:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50606746.1060702@rwth-aachen.de>
References: <505B03D7.2050300@rwth-aachen.de>
	<201209201415.17078.chunkeey@googlemail.com>
	<50606746.1060702@rwth-aachen.de>
Date: Mon, 24 Sep 2012 20:16:19 +0530
Message-ID: <CAD2nsn3m2sDo9e5bU4Km_9hG42XrgGxicFUguTg8CX0G6yaimg@mail.gmail.com> (sfid-20120924_164627_084367_3F066D02)
Subject: Re: communication between driver and wpa_supplicant
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sabrina Schulte <sabrina.schulte@rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2012 at 7:29 PM, Sabrina Schulte
<sabrina.schulte@rwth-aachen.de> wrote:
> Hi,
>
> I do not know if this is the right mailing list for this question, but I am
> looking for a way to handle the communication between the driver and the
> wpa_supplicant. Is there an interface that I could use to handle this
> communication, e.g. calling a function from the kernel in the userspace?

ex: nl80211 helps us to do it.
http://linuxwireless.org/en/users/Documentation
To the very curious user :)

>
> I am very thankful for every hint.
>
> Regards,
> Sabrina
>
> --
> sabrina.schulte@rwth-aachen.de
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
