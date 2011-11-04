Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63733 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KDFVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 01:21:45 -0400
Received: by ywf7 with SMTP id 7so2127713ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 22:21:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABDyM6TFm3HPTiJybCkg4fUetKaF2P+qM8DUnHJ5Y+yJAG2i4g@mail.gmail.com>
References: <CABDyM6TFm3HPTiJybCkg4fUetKaF2P+qM8DUnHJ5Y+yJAG2i4g@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 4 Nov 2011 16:21:22 +1100
Message-ID: <CAGRGNgXNbdBcKhn-FJEoWVMAcEvi5CLKKhM+B0wzX0=1L8CYow@mail.gmail.com> (sfid-20111104_062156_496598_A188673D)
Subject: Re: iwlagn master mode
To: Richard Yao <ryao@cs.stonybrook.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Richard,

On Fri, Nov 4, 2011 at 12:14, Richard Yao <ryao@cs.stonybrook.edu> wrote:
> Someone I know had to boot into his Mac Book Air's recovery mode and
> he needed a wireless connection. Since the university's wireless
> network was inaccessible to both of us, I tried setting up an access
> point via my laptop so he could connect to the internet through my
> computer's wired ethernet connection. I quickly learned that master
> mode wasn't supported, which made this impossible.
>
> Is it possible to get master mode support in the iwlagn driver?

As far as I know, it is supported.

In the case you describe, you have a two options:
1. Use Network Manager or equivalent to set up an "AdHoc" network
("Create New Wireless Network")
2. Use hostapd to set up the access point. See here:
http://wireless.kernel.org/en/users/Documentation/hostapd

You cannot set master mode without using hostapd.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
