Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62190 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2GJR3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:29:24 -0400
Received: by pbbrp8 with SMTP id rp8so567288pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 10:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFub=KTPnR4Ydyt9hNhEzAN4HFe0ZN7m4W3cYGtiAy5KLYCZEg@mail.gmail.com>
References: <1341834481-1831-1-git-send-email-ozancag@gmail.com>
 <CAFub=KTDYF71=GiEMAdVNDTKeMMZYFy4C0YqPpvhOE-+MShrKQ@mail.gmail.com> <CAFub=KTPnR4Ydyt9hNhEzAN4HFe0ZN7m4W3cYGtiAy5KLYCZEg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 10 Jul 2012 10:29:03 -0700
Message-ID: <CAB=NE6ViFGRFh5PGpjOaXmTO13+C2jkpyGwLvc+yBnP9FLyY-Q@mail.gmail.com> (sfid-20120710_192928_055812_A6476282)
Subject: Re: [PATCH] compat: Fix setting $TARGET
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 5:16 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> On Tue, Jul 10, 2012 at 1:11 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> On Mon, Jul 9, 2012 at 2:48 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>>> commit 61077651424add644401b927b52681a191bbd7f1 moved the list of
>>> kernels above which broke the $TARGET substitutions in them.
>>>
>>> Move the TARGET detection above of everything to fix this.
>>>
>
> Well if you apply my today's commit which dynamically generates ARCH
> dependent deb names when downloading, you do not need to apply this
> since wget is called after setting TARGET in get_ubuntu_kernels().

OK I applied the other one and skipped this one, thanks!

  Luis
