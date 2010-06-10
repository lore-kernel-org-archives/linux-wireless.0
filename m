Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52422 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FJFxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:53:36 -0400
Received: by yxl31 with SMTP id 31so1296324yxl.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 22:53:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19472.32107.793016.762850@gargle.gargle.HOWL>
References: <4C107563.3010709@yatharthgupta.com> <19472.30680.855993.112084@gargle.gargle.HOWL>
	<4C1078D4.3070604@yatharthgupta.com> <19472.31157.569068.781531@gargle.gargle.HOWL>
	<4C1079E0.6090605@yatharthgupta.com> <19472.32107.793016.762850@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Jun 2010 22:53:15 -0700
Message-ID: <AANLkTimVqheuVKI3tCpSGoDHRaEcexDFwm77wj_9_QJU@mail.gmail.com>
Subject: Re: issues while attempting ath9k_htc to work with ubuntu 10.04,
	device TL-WN721N
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Yatharth <y@yatharthgupta.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 9, 2010 at 10:51 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Yatharth wrote:
>> Here is the output of 'modinfo ath9k_hw'
>>
>> Ubu-VM:~/tmp/compat-wireless-2010-06-05$ modinfo ath9k_hw
>> filename:       /lib/modules/2.6.32-22-generic/updates/cw/ath9k_hw.ko
>
> What is the 'cw' directory ?

Its ubuntu's compat-wireless package, linux-backport-modules. Try to
uninstall that or rm -rf it.

  Luis
