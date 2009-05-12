Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41349 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbZELIQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 04:16:24 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M3nA0-0002iM-77
	for linux-wireless@vger.kernel.org; Tue, 12 May 2009 08:16:24 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 08:16:24 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 08:16:24 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: rt73usb Access point status
Date: Tue, 12 May 2009 09:16:12 +0100
Message-ID: <wf4ovqrb1v.fsf@calligramme.charmers>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com> <efe7343f0904300656g127e83e1ge0b21060d6a69955@mail.gmail.com> <wfk54zu7t6.fsf@calligramme.charmers> <efe7343f0905020334g3df47d87j31a351a878968312@mail.gmail.com> <20090511035515.83c21b0c.cjsthompson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"Christoph .J Thompson"
<cjsthompson@gmail.com>
writes:

> On Sat, 2 May 2009 11:34:31 +0100
> Luis Correia <luis.f.correia@gmail.com> wrote:
>> No, the bug is not in hostapd.
>>=20
>> As Johannes says, the bug is in the driver.
>> Apparently, the driver is unable to get the ACK from the hardware an=
d
>> thus unable to report that ACK back to hostapd.
>>=20
>> So the hostapd hack works, as long as there are enough room for
>> retransmit supposely lost frames.
>>=20
>> I can't explain this well enough in English, sorry.
>
> Apparently there is no bug in neither hostapd nor the
> driver. From what I understood the hardware is incapable
> of doing it or the firmware needs to be fixed.

Is there any prospec of persuading Ralink either to release
a mended version of the firmware or to free the old version?

What is it that Alexandre Becholey is doing, though? It
looked promising to me.

>> To be completely honest with you in this whole AP issue, here's what=
 I
>> used to say to my friends: "if you need an AP working flawlessly und=
er
>> Linux, got with the Atheros b/g hardware".
>> But that was in the madwifi days, I haven't tested it with the curre=
nt
>> mac80211 based driver.
>
> But if he can't use anything else than a USB dongle than
> Atheros is useless.

Quite. No free PCI slots, for example.

> In my case I can't use anything else than a USB dongle on
> my AP because there's only one case you can use for this
> embedded board (ALIX 2d3) and it doesn't have a hole for
> an external antenna as it's the model with 3 ethernet
> ports.

I think my solution to that would involve HSS tools, but
your point is a good one.

--=20
J=C3=B3n Fairbairn                                 Jon.Fairbairn@cl.cam=
=2Eac.uk


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
