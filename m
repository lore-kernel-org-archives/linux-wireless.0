Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:46925 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeBLThG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 14:37:06 -0500
Received: by mail-ot0-f175.google.com with SMTP id w10so1532517ote.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2018 11:37:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
From: Rosen Penev <rosenp@gmail.com>
Date: Mon, 12 Feb 2018 11:37:05 -0800
Message-ID: <CAKxU2N-adq+3NaJWwL=RzH7TF4RwzHYYqrE2ungN5h-PB8DhQg@mail.gmail.com> (sfid-20180212_203710_694280_459943DA)
Subject: Re: 802.11ac devices that use Minstrel_HT
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:05 AM, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Hello,
>
> It seems that Minstrel_ht rate adaptation algorithm supports 802.11ac VHT
> rates.
> Can you refer me to some 802.11ac devices that use this rate adaptation
> algorithm?
> I need to modify the rate adaptation algorithm however all 802.11ac devices
> that I know have moved this functionality to (closed) firmware.
>
Devices with support for the mt76 do not do rate adaptation in
firmware as far as I can tell. This may also be the case with the
mt7601u driver.
> Best,
> Ali
