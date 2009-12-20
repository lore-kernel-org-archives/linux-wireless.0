Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:52619 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZLTVvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 16:51:31 -0500
Received: by iwn1 with SMTP id 1so3291892iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 13:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890912201348w429fcc16gf4d66e01653262ae@mail.gmail.com>
References: <200912201510.51812.linux-wireless@mrs.ro> <43e72e890912201342w2f5916d0p2b30683ccbb5dbfe@mail.gmail.com>
	<43e72e890912201348w429fcc16gf4d66e01653262ae@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 20 Dec 2009 13:51:10 -0800
Message-ID: <43e72e890912201351x25963a30r80299c7bb2c405b8@mail.gmail.com>
Subject: Re: Intel 4965 HT rates
To: Valentin Manea <linux-wireless@mrs.ro>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 20, 2009 at 1:48 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sun, Dec 20, 2009 at 1:42 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> So it appears to be done explicitly in software, not sure if hardware
>> does support HT40 on 2.4 GHz band on the 4965, Intel folks would
>> though.
>
> Just checked 2.6.29 code and its the same there.

Except its called priv->hw_params.fat_channel there.

  Luis
