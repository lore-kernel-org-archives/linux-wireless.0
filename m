Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753619AbdK1MV5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 07:21:57 -0500
Message-ID: <1511871714.7841.0.camel@sipsolutions.net> (sfid-20171128_132228_200169_B2092BE1)
Subject: Re: platform regulatory.0: Direct firmware load for regulatory.db
 failed with error -2
From: Johannes Berg <johannes@sipsolutions.net>
To: Cristian <caravena@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 28 Nov 2017 13:21:54 +0100
In-Reply-To: <CABwnbUmWhxx0oN8H1H-0Qy9OYczszFX7yoLLud7VSBLxTn7Dyg@mail.gmail.com> (sfid-20171128_130918_213277_F9199602)
References: <CABwnbUmWhxx0oN8H1H-0Qy9OYczszFX7yoLLud7VSBLxTn7Dyg@mail.gmail.com>
         (sfid-20171128_130918_213277_F9199602)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-28 at 09:09 -0300, Cristian wrote:
> Hello,
> 
> Linux version 4.15.0-041500rc1-generic
> 
> Report in:
> https://bugzilla.kernel.org/show_bug.cgi?id=198013
> 
> dmesg:
> [    5.663292] platform regulatory.0: Direct firmware load for
> regulatory.db failed with error -2

Yeah, nothing to worry about.

Seth will publish the file, and then people can get it, but until then
it's not actually needed.

johannes
