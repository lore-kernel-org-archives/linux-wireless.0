Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2FKSRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 14:17:47 -0400
Received: by pbbrp8 with SMTP id rp8so5925542pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 11:17:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOreOvXM9MPRz67+WCoCwODrz0_FG4GTR5v9imQJyZt5DTDWQw@mail.gmail.com>
References: <CA+7oygd1dfn=Vj7V1h_vVvXPNym_Ake7UNWf1UuVWfxzm5g+NQ@mail.gmail.com>
	<CAOreOvXM9MPRz67+WCoCwODrz0_FG4GTR5v9imQJyZt5DTDWQw@mail.gmail.com>
Date: Mon, 11 Jun 2012 14:17:46 -0400
Message-ID: <CA+7oygcfLTRsPKMQkb-0vYQaE42i+j_E3bQg75UzVGVG51dhjA@mail.gmail.com> (sfid-20120611_201751_100406_BDD5437E)
Subject: Re: anyone know any dual-band USB devices with monitoring mode in Linux?
From: George Nychis <gnychis@gmail.com>
To: Mark Davis <marked86@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your suggestions!  I ended up grabbing an RaLink RT3572 for
$12 on Amazon with the AE1000:
http://www.amazon.com/gp/product/B003VYH1UE/ref=oh_details_o00_s00_i00

Not a problem kicking it in to monitoring mode with the rt2x00 driver,
and it is reporting proper signal strengths unlike my ar9280.
Perfect.

- George


On Thu, Jun 7, 2012 at 6:24 PM, Mark Davis <marked86@gmail.com> wrote:
>
> On Wed, Jun 6, 2012 at 11:14 PM, George Nychis <gnychis@gmail.com> wrote:
> > Hi all,
> >
> > I've been using the Sony UWA-BR100 (AR9280) with ath9k_htc, and there
> > is clearly a bug with reporting signal strengths which I need to be
> > correct.  I've reported the bug, but this might not be fixed in time
> > for a deadline I have coming up, and the bug is in the firmware out of
> > my reach.
> >
> > So I was wondering if anyone knows of any alternative USB dual-band
> > wireless cards that support monitoring mode in Linux.  I'd _greatly_
> > appreciate it... doesn't need to be Atheros based.
> >
> > - George
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> http://bit.ly/LzgJiA
>
> I primarily use AWUS050NH / AWUS051NHs. Dell Wireless 1450 adapters
> are also decent (though they probably perform better in 2.4GHz than
> 5GHz). I'm not really a fan of AR9170 hardware.
>
> -mark
