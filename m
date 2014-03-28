Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58568 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaC1H1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:27:08 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so3219503wgh.17
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 00:27:06 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <5334F8E7.1070803@candelatech.com>
References: <5334F8E7.1070803@candelatech.com>
Date: Fri, 28 Mar 2014 08:27:06 +0100
Message-ID: <CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com> (sfid-20140328_082712_733470_4F9FFACB)
Subject: Re: Setting txpower fails?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2014 at 5:21 AM, Ben Greear <greearb@candelatech.com> wrote:
> Any idea why this isn't working?
>
> Kernel is 3.9.11+, driver is ath9k.
>
> [root@ct523-9292 lanforge]# iwconfig wlan0
> wlan0     IEEE 802.11abgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>
> [root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
> [root@ct523-9292 lanforge]# echo $?
> 0
> [root@ct523-9292 lanforge]# iwconfig wlan0
> wlan0     IEEE 802.11abgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>
> [root@ct523-9292 lanforge]#
>

Which version of wireless-tools?
Why don't you use modern iw?

- Sedat -
