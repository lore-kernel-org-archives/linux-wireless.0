Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:35536 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759954AbdAKKXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 05:23:06 -0500
Received: by mail-yw0-f178.google.com with SMTP id l19so21865530ywc.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 02:23:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170111101031.GA2927@redhat.com>
References: <CAAfyv37ZFHkZWfq_gAB7XiqtDqVeT+SG7jfXxnCq2fyzYEKX_w@mail.gmail.com>
 <20170111101031.GA2927@redhat.com>
From: Belisko Marek <marek.belisko@gmail.com>
Date: Wed, 11 Jan 2017 11:23:00 +0100
Message-ID: <CAAfyv350ugd4=EhoZPq9uooCwMfzcPtnzKrfXHVse1wroW4oiA@mail.gmail.com> (sfid-20170111_112311_037707_01174722)
Subject: Re: ad-hoc in 5GHz
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, Jan 11, 2017 at 11:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi
>
> On Wed, Jan 11, 2017 at 09:36:00AM +0100, Belisko Marek wrote:
>> this should be general question. I'm using [0] ralink driver to setup
>
> It's Realtek not Ralink, right ?
Ah sorry yes it's Realtek.
>
>> ad-hoc mode. It works fine in 2.4GHz band (channel 1) but when I try
>> to setup ad-hoc for 5GHz (channel 50) it seems it's not working at all
>> (I tried to scan with other device but I cannot ad-hoc network). So my
>> question should ad-hoc mode work in 5GHz band also or there are some
>> restrictions? Many thanks.
>
> Depending on regulatory setting IBSS or IR (initialize radiation) can be
> prohibited on some 5GHz channels, check "iw phy" to see which 5GHz channels
> are allowed to use. If HW hardcoded regulatory do not prohibits IBSS on all
> 5GHZ channels it can be matter or setting proper regulatory domain
> (configure timezone properly and then setregdomain will set domain based
> on it).
I did check that and I use 'iw reg set US' (to setup other regulatory
than 00). But despite of that
I still cannot get 5GHz working. Maybe it's driver issue. Thanks.
>
> Regards
> Stanislaw

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
