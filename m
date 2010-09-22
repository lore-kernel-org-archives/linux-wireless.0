Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43793 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab0IVRQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:16:44 -0400
Received: by gwj17 with SMTP id 17so243237gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 10:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285126234.2142.3.camel@malta>
References: <1285126234.2142.3.camel@malta>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Sep 2010 10:16:23 -0700
Message-ID: <AANLkTimFa0-JpAQpvcVcsoUqbkeBy8FAVZk1Qwj--aHf@mail.gmail.com>
Subject: Re: Typo in wmi.c?
To: Estoy <estoy@voxsobrius.org>, Vipin Mehta <Vipin.Mehta@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 8:30 PM, Estoy <estoy@voxsobrius.org> wrote:
> compat-wireless-2010-09-20/drivers/staging/ath6kl/wmi/wmi.c
>
> Line 1465: i&bhi   ?
>
> Anyway I'm getting an "i" undefined error at line 1465 when building
> from this release/file.

Can you give more context, I don't see that on linux-next.git on line
1465... Also please e-mail the maintainer, which I've added.

  Luis
