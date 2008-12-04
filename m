Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:6652 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYLDBEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 20:04:51 -0500
Received: by fk-out-0910.google.com with SMTP id 18so3185912fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 17:04:49 -0800 (PST)
Message-ID: <45e8e6c40812031704l13cb87e8j7120530a45124775@mail.gmail.com> (sfid-20081204_020455_427027_955F0022)
Date: Wed, 3 Dec 2008 17:04:48 -0800
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

Hi.  The drivers that support mesh point mode are listed here:
http://o11s.org/trac#DriverStatus
or, more officially, check the "mesh" column here:
http://linuxwireless.org/en/users/Drivers/

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
