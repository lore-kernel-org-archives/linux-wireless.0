Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38596 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab0HCQw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 12:52:29 -0400
Received: by gwb20 with SMTP id 20so1665842gwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Aug 2010 09:52:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280853967.26054.2.camel@mj>
References: <20100731190245.76295404FA@repository3.orbit-lab.org>
	<1280853967.26054.2.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Aug 2010 09:52:07 -0700
Message-ID: <AANLkTikfNoPJW1+hg57D2ZaZECy9=KVTJqOtzBRfJwDn@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-07-31 is baked
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 3, 2010 at 9:46 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Sat, 2010-07-31 at 15:02 -0400, Compat-wireless cronjob account
> wrote:
>> compat-wireless code metrics
> ...
>> Base tree: linux-next.git
>> Base tree version: next-20100730
>> compat-wireless release: compat-wireless-2010-07-13-4-g04898a5
>
> Can we have the version based on 2.6.35 please?  Even if it's the same
> as 2.6.35-rc6, the release based compat-wireless would be more readily
> adopted.
>
> Linux 2.6.35 adds ath9k_htc among other things.  Ubuntu 10.04 provides
> compat-wireless based on 2.6.34 now.  Ububtu users keep asking about
> ath9k_htc.  Let's make them happy :)
>

Sure thing, I'll work on that today.

  LUis
