Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33459 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752677AbdC2Q0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 12:26:46 -0400
Received: by mail-wr0-f180.google.com with SMTP id w43so22503396wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 09:26:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: walter@strametz.eu
Cc: linux-wireless@vger.kernel.org
Subject: Re: compile driver for rtl8192su
Date: Wed, 29 Mar 2017 18:26:42 +0200
Message-ID: <3808701.OuIp1c5iyn@debian64> (sfid-20170329_182649_363086_7AABABF2)
In-Reply-To: <CAMFBgyj=A4GmOyO3wkOgVLCOjc35RC4n8yJm+z+cxO3U=OH_qQ@mail.gmail.com>
References: <CAMFBgyj=A4GmOyO3wkOgVLCOjc35RC4n8yJm+z+cxO3U=OH_qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, March 29, 2017 2:51:13 PM CEST walter strametz wrote:
> I try to get my D-Link N300 running and compiled the sources on
> github (chunkeey - rtl8192su).  Other trials also failed, because the
> driver-source is not compatible with the (newer) kernel.
the 4.4.y kernel is too old.

Only kernels built from the latest wireless-testing.git are compatible.
If you want to know more about wireless-testing.git then visit the
wireless wiki's Git-Guide:
<https://wireless.wiki.kernel.org/en/developers/Documentation/git-guide>

Regards,
Christian
