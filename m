Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36755 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759728AbcHaJD2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 05:03:28 -0400
Received: by mail-yw0-f173.google.com with SMTP id u134so26835502ywg.3
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2016 02:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+na77=379E2tRDnbDzE=LOrz9ObahLTLoBTg+hhd8DBw@mail.gmail.com>
References: <CABPxzY+na77=379E2tRDnbDzE=LOrz9ObahLTLoBTg+hhd8DBw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 31 Aug 2016 14:32:49 +0530
Message-ID: <CABPxzYJHMTSCvoLaLohfKxHDVR3uQk8jKGF3aDtMWJu4-fxfuw@mail.gmail.com> (sfid-20160831_110500_578599_2F82A9E5)
Subject: Re: [RFD] mac80211: Handling local operating class in (E)CSA
To: linux-wireless <linux-wireless@vger.kernel.org>,
        wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2016 at 12:56 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
>
> Hi,
>
> Some AP's use local operating class in (E)CSA IE's. Currently
> mac80211 fails the parsing of those IE's and results in a
> disconnection.
>
> What is the best way to add support for local operating classes?
>
> a) Maintaining a per country operating class table in cfg80211
>
> b) Embed operating class info in regdb.txt (crda)
>
> c) Remove the usage of band to calculate frequency? I dont know
> of a generic formula to calculate this across bands. So not possible.
>
Any ideas?
