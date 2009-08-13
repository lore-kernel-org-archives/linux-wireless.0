Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:40219 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZHMUFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:05:42 -0400
Received: by an-out-0708.google.com with SMTP id d40so846290and.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 13:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250193402.21250.12.camel@johannes.local>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	<1250193402.21250.12.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 13:05:23 -0700
Message-ID: <43e72e890908131305o4e44a7ebjf780ee811d08052b@mail.gmail.com>
Subject: Re: [PATCH 00/20] wireless: cleanup and organize drivers kconfig
	better
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 12:56 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-08-13 at 15:31 -0400, Luis R. Rodriguez wrote:
>> This series consists of a lot of organizational changes on
>> the wireless drivers kconfig. We also do some cleanup towards the
>> end to help simplify the individual kconfig entries. Hope is to
>> help users compiling their kernels find their drivers as quickly
>> as possible. It also makes it easier to understand which driver
>> are for what vendor chipsets as some of vendor drivers were
>> completely scattered apart.
>
> Ok, I can buy the sorting part, so Intel devices are listed together.
> Maybe even with a separator inbetween, like
>
> Intel devices
> [x] ipw2100
> [x] ipw2200
> [x] iwlwifi
> ...
>
> Atheros Devices
> ...
>
> but I think submenus are overkill since that means you need to go in
> even deeper, this stuff is already pretty deeply hidden.

OK sounds good. Will respin eventually.

  Luis
