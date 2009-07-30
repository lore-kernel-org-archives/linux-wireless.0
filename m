Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:53457 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZG3On3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:43:29 -0400
Received: by ywh13 with SMTP id 13so716773ywh.15
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 07:43:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A719C44.6050208@gmail.com>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
	<4A719C44.6050208@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jul 2009 07:43:09 -0700
Message-ID: <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
To: Roman Macko <rmacko72@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 6:12 AM, Roman Macko<rmacko72@gmail.com> wrote:
> Luis,
>
> I used stable version 2.6.30.
> Anyway I downloaded bleeding edge version and ran script check_depmod.
> But it created new configuration in /etc/depmod.d directory instead of
> creating
> global configuration /etc/depmod.conf what I did. It doesn't work in that
> way.

What do you mean it doesn't work that way?
Do you mean you tested it and that it didn't work?

> I can read in manual pages of depmod.conf that depmod.d directory serves for
> configuration on per-module basis,
> so I think you can change the order of proceding directories for particular
> module only there.

Nope. Even Ubuntu uses their own file in there for the same purpose:

mcgrof@tux ~ $ cat /etc/depmod.d/ubuntu.conf
search updates ubuntu built-in

> But I don't know how to name that file or if my thought is right at all.

The man page needs some updating.

  Luis
