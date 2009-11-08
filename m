Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:40919 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZKHWBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 17:01:48 -0500
Received: by iwn10 with SMTP id 10so1976995iwn.4
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 14:01:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <79f7ecbe0911072257o385ed65h238d2ed7261321f6@mail.gmail.com>
References: <79f7ecbe0911072257o385ed65h238d2ed7261321f6@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 8 Nov 2009 14:01:33 -0800
Message-ID: <43e72e890911081401m196e5fdct8b1da2e7d87ccd14@mail.gmail.com>
Subject: Re: [PATCH 1/1] ath_hif_usb: changed 'typedef struct' to 'struct' &
	replaced UsbTxQ with 'struct sk_buff *'
To: RCore Linux <rshlinux@gmail.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2009 at 10:57 PM, RCore Linux <rshlinux@gmail.com> wrote:
> Replaced structure definitions from 'typedef struct' to 'struct
> <struct>' ,  replaced UsbTxQ references to 'struct sk_buff *'
>
> Signed-off-by: Ramesh R <rshlinux@gmail.com>

Lines are wrapped after 80 characters therefore making this patch
malformed. Please resubmit with an agent that won't wrap it. Also
please exclude linux-wireless from the e-mail as the driver is not yet
upstream.

  Luis
