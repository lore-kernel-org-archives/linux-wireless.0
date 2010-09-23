Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51268 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0IWRbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 13:31:51 -0400
Received: by iwn5 with SMTP id 5so1612418iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 10:31:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <260374.78183.qm@web56801.mail.re3.yahoo.com>
References: <D5F495A696324E51917098BB2D9BE5C8@ChuckPC> <260374.78183.qm@web56801.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Sep 2010 10:31:29 -0700
Message-ID: <AANLkTik6r_xUD4Ct2iuWWbXPLUnDYb1HPzLTaym=GW8L@mail.gmail.com>
Subject: Re: Compiling carl9170
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 7:11 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> I don't have atheros cards and this might be idiotic question, but won't ar9170 and carl9170 collide, since they cover the same VIDs ?
>
> http://linuxwireless.org/en/users/Drivers/ar9170#available_devices
> http://wireless.kernel.org/en/users/Drivers/carl9170#available_devices

Yes, distributions should pick carl9170 over ar9170 though as ar9170
will be removed from the kernel after a good kernel try out of it.

  Luis
