Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:24353 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYLDBLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 20:11:32 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2653819fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 17:11:30 -0800 (PST)
Message-ID: <45e8e6c40812031711w3e4fe31bh7228037014475300@mail.gmail.com> (sfid-20081204_021135_743265_82909B1F)
Date: Wed, 3 Dec 2008 17:11:30 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Chanthearith HUON" <chanthearith.huon@telecom-sudparis.eu>
Subject: Re: failed to create interface: -1
Cc: linux-wireless@vger.kernel.org, Hakima.Chaouchi@it-sudparis.eu
In-Reply-To: <49371FE4.2050507@telecom-sudparis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49371FE4.2050507@telecom-sudparis.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, that is a b43-supported card and that should work.  Have you
installed the b43 firmware?  Are you using the actual b43 driver?
Thanks,

  -Andrey

On Wed, Dec 3, 2008 at 4:10 PM, Chanthearith HUON
<chanthearith.huon@telecom-sudparis.eu> wrote:
> Hi everyone,
>
> # iw dev wlan0 interface add mesh type mp mesh_id 10
> failed to create interface: -1
>
> I searched the web and read the archives but that did not help.
>
> Any ideas of what went wrong?
>
> Environment:
> Distribution: ubuntu 8.10 Intrepid Ibex with kernel 2.6.27
> Wireless card: Linksys wmp54g pci with ssb driver (there should be no
> problem as listed in http://linuxwireless.org/en/users/Devices/PCI)
>
> Thanks,
> Thierry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Andrey Yurovsky
cozybit Inc.
