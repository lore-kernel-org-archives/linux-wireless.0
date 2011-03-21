Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52545 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1CUPLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:11:01 -0400
Received: by wwa36 with SMTP id 36so7593561wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 08:11:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300647934.31197.0.camel@gnutoo-laptop>
References: <1298390485.2575.6.camel@gnutoo-laptop>
	<AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
	<1300647934.31197.0.camel@gnutoo-laptop>
Date: Mon, 21 Mar 2011 20:41:00 +0530
Message-ID: <AANLkTink_44QnwzQE2gZXsV3QVi5-KW_oAkYozjyhQhr@mail.gmail.com>
Subject: Re: ath9k stopped queue bug
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 12:35 AM, Denis 'GNUtoo' Carikli
<GNUtoo@no-log.org> wrote:
> On Wed, 2011-02-23 at 11:04 +0530, Mohammed Shafi wrote:
>> please try with debug messages enabled sudo modprobe ath9k debug=0x2
>> (or)
>> sudo modprobe debug=0x82 (this produces lots of log)
> # cat /sys/kernel/debug/ieee80211/phy*/queues
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/965
> 03: 0x00000000/0
> # uname -a
> Linux gnutoo-laptop 2.6.38-gnutoo-0001 #2 SMP Sat Mar 19 19:07:58 CET
> 2011 x86_64 GNU/Linux
>
> The problem persist and dmesg still doesn't have the debug infos...


regarding the debug info you need to be enable following in config.mk or .config
CONFIG_ATH_DEBUG=y
CONFIG_ATH9K_DEBUGFS=y

>
> Denis.
>
>
>
