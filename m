Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:38966 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYGKXh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 19:37:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so810132and.103
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2008 16:37:23 -0700 (PDT)
Message-ID: <43e72e890807111637x6432010fk309bffb99ce63ddb@mail.gmail.com> (sfid-20080712_013731_630142_56A9FD89)
Date: Fri, 11 Jul 2008 16:37:22 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Compilation Problem
Cc: "Chris Calitz" <chris@sabest.co.za>, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0807111430w46b8a318yb35d787e084205b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1215680282.6376.5.camel@chris-laptop>
	 <b6c5339f0807111430w46b8a318yb35d787e084205b5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 11, 2008 at 2:30 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Jul 10, 2008 at 4:58 AM, Chris Calitz <chris@sabest.co.za> wrote:
>> Hi Everyone
>
> Hi!
>
>> I have found that the compact-wireless driver apparently fixes this
>> issue but when I try to build this driver I get the following errors.
>
>> /home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/mac80211_hwsim.c: In function 'init_mac80211_hwsim':
>
> For now you can just turn off building mac80211_hwsim; it's a test driver so
> you don't need it, and I don't think it is fully back-ported.  Edit config.mk
> and set CONFIG_MAC80211_HWSIM=n.

TIm sent in a patch which backports this call correctly, should be
propagated to a new tarball by tomorrow.

  Luis
