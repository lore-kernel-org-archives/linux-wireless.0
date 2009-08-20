Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:54958 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbZHTHMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 03:12:42 -0400
Received: by iwn42 with SMTP id 42so320121iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 00:12:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
References: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 20 Aug 2009 00:12:24 -0700
Message-ID: <43e72e890908200012x23b7773dvf215676726a514e5@mail.gmail.com>
Subject: Re: Linux Kernel Wireless stack presentation
To: Rami Rosen <ramirose@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:02 AM, Rami Rosen<ramirose@gmail.com> wrote:
> Folks,
>
>  I am giving on Thursday next week a lecture about the Linux Kernel
> Wireless stack in a
> Linux User Group in Herzelia (Israel).
>
>  The slides are available online now, so I thought some of you might
> be interested
> to take a look; the presentation is very detailed (over 110 pages).
>
> see:
> http://tuxology.net/wp-content/uploads/2009/08/wirelessLecHerzelinux.pdf

A few comments:

* Ditch iwconfig and refer to iw
* ath5k/ath9k do not have any firmware burned onto any "ROM", the
devices just do not require software, everything is done by the driver

   Luis
