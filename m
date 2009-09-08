Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42160 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZIHGD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 02:03:56 -0400
Received: by fxm17 with SMTP id 17so2371182fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 23:03:58 -0700 (PDT)
From: "Marcel" <marcelcastrobr@gmail.com>
To: "'Luis R. Rodriguez'" <mcgrof@winlab.rutgers.edu>,
	"'AMAR SAHUKAR'" <amarsahu7@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <b55cabb00909070639s4a6f3c1cl8c3e2eccceaf81e8@mail.gmail.com> <43e72e890909071436ub99bddbx3dd531d09f322b4a@mail.gmail.com>
Subject: RE: compat-wireless-old for ARM
Date: Tue, 8 Sep 2009 08:10:59 +0200
Message-ID: <70EB52E9BF7F43BBBBC899826FD0D3C4@inin.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
In-Reply-To: <43e72e890909071436ub99bddbx3dd531d09f322b4a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,
	Do you think it should be viable to bring it down to kernel 2.6.22
using armeb?
	If so, I can help to test since I am very interested in ath5k.
Regards
Marcel

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Luis R. Rodriguez
Sent: den 7 september 2009 23:37
To: AMAR SAHUKAR
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless-old for ARM

On Mon, Sep 7, 2009 at 6:39 AM, AMAR SAHUKAR<amarsahu7@gmail.com> wrote:
> Hi,
>          I wanted to know the procedure to follow for installing
> compat-wireless-old on ARM platform. I am using a Netgear WG111V3 usb
dongle
> which uses a rtl8187 chipset. I will be pleased if you can help me with
> this.

compat-wireless-old has not been updated for ages. Today is possible
to bring compat-wireless (instead of compat-wireless-old) down to
older kernels we previously could not since we no longer are using the
netdevice multiqueue support. I was able to bring compat-wireless down
to 2.6.25 -- at least compile-wise, there is also code present to help
bring it down to older kernels, we just need someone to test/help
finish the rest.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

