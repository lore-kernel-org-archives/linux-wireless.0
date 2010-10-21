Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38506 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0JUR2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 13:28:25 -0400
Received: by ewy7 with SMTP id 7so413774ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 10:28:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287680315.4759.4.camel@wwguy-ubuntu>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com> <1287680315.4759.4.camel@wwguy-ubuntu>
From: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Date: Thu, 21 Oct 2010 15:28:03 -0200
Message-ID: <AANLkTinDTJAwOf3ZqsT22SPQBV7m6MrWO59KzSWr2FBH@mail.gmail.com>
Subject: Re: Modifying the driver iwlwifi
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the quick reply,

   Could you give me something to start? I saw a lot of files in
"compat-wireless-2010-10-20/drivers/net/wireless/iwlwifi" is it ?

-
Cassiano Valle Tartari
Computer Engineer

Tel: +55.48.84474818
Email: falecom@cassianotartari.eng.br
Site: http://www.cassianotartari.eng.br


On Thu, Oct 21, 2010 at 2:58 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>
> Hi Cassiano,
>
> On Thu, 2010-10-21 at 09:17 -0700, Cassiano Tartari, Eng. wrote:
> > Hi,
> >
> >   I'm a masters student of Automation and Systems Engineering at
> > Federal University of Santa Catarina in Brazil. I'd like to know if it
> > is possible to modify the implementation of iwlwifi because I need to
> > decrease the time of association between the client and the AP. I'd
> > like to implement something in the same way like I read in an article,
> > project QuickWifi. Its basic idea is that a client doesn't wait each
> > response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
> > DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
> > an end-to-end connection is available.
> >
> >     I need this to my work, it will be used for the communication
> > between a moving vehicle and a fixed point on the street.
> >
>
> It is an open source project, so please feel free to make the
> modifications; but please do follow the upstream process and submit the
> patch to either "internal-wifi-devel@linux.intel.com" mailing list or
> "linux-wireless@vger.kernel.org" mailing list for review
>
> Thanks
> Wey
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
