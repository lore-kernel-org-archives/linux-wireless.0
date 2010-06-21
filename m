Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57894 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0FUWSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:18:55 -0400
Received: by pwj8 with SMTP id 8so535145pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 15:18:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277157673.24550.5.camel@mj>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com>
	<1277157673.24550.5.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 15:18:35 -0700
Message-ID: <AANLkTinRqbLH1NOx0o8GNfMaCa1N9NxlsqNzWZWzEyQt@mail.gmail.com>
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, j@w1.fi,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 3:01 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2010-06-21 at 11:32 -0700, Luis R. Rodriguez wrote:
>
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
>> > Subject         : hostap_pci: infinite registered netdevice wifi0
>> > Submitter       : Petr Pisar <petr.pisar@atlas.cz>
>> > Date            : 2010-06-02 20:55 (19 days old)
>>
>> The last entry on this one says we are not sure how to fix this...
>
> That was a patch posted for that by Tim Gardner:
> https://patchwork.kernel.org/patch/105008/
>
> The patch is applied to wireless-testing
> (d6a574ff6bfb842bdb98065da053881ff527be46)
>
> $ git describe d6a574ff6bfb842bdb98065da053881ff527be46
> v2.6.34-4694-gd6a574f
>
> I understand it was applied after 2.6.34, so it should be backported to
> 2.6.34 and whatever older kernels are affected.

Tim can this be sent for stable?

  Luis, a stable whore
