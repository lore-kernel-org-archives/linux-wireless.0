Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40726 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZHVT3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 15:29:39 -0400
Received: by bwz19 with SMTP id 19so914327bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 12:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090822134044.GC6762@hash.localnet>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
	 <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com>
	 <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com>
	 <20090822124709.GA6762@hash.localnet>
	 <b637ec0b0908220602v3b9c2a35ob1e44d70f131890c@mail.gmail.com>
	 <20090822134044.GC6762@hash.localnet>
Date: Sat, 22 Aug 2009 21:29:39 +0200
Message-ID: <b637ec0b0908221229k5a738f8dgc0aa9e58337c743e@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob.
Unfortunately the patch doesn't apply at all with compat-wireless,
there's no "flush_workqueue" before "local->suspended" there....

Please advice.
Regards,
Fabio




On Sat, Aug 22, 2009 at 3:40 PM, Bob Copeland<me@bobcopeland.com> wrote:
> On Sat, Aug 22, 2009 at 03:02:26PM +0200, Fabio Comolli wrote:
>> Hi Bob.
>>
>> I'm not a git user. How can I user wireless-testing without git? Is
>> there a patch or seomething?
>
> No, I'm unaware of a way to get it without git.  Well, okay, try
> compat-wireless, but be sure to use the 'bleeding edge' compat-wireless,
> and post the contents of its 'git-describe' file with the warnings so
> I can be sure we're on the same page.
>
> http://wireless.kernel.org/en/users/Download
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>
