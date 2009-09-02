Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61038 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZIBWSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 18:18:47 -0400
Received: by iwn6 with SMTP id 6so531859iwn.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 15:18:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090902214601.GB5614@mosca>
References: <20090901170030.GE8261@mosca> <20090902071849.GM4363@almesberger.net>
	<20090902214601.GB5614@mosca>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 2 Sep 2009 15:18:28 -0700
Message-ID: <43e72e890909021518s411c3e0ap2ec94f9ff6c01b68@mail.gmail.com>
Subject: Re: ar6k driver
To: Werner Almesberger <werner@openmoko.org>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>, Len.Widra@atheros.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 2, 2009 at 2:46 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> On Wed, Sep 02, 2009 at 12:18:49AM -0700, Werner Almesberger wrote:
>> Luis R. Rodriguez wrote:
>> > I know I found it last time I looked through the openmoko wiki but
>> > it took me a lot of time to actually find the git tree and then
>> > the branch name. Today I gave up looking for it so resorting to
>> > asking you for the git url.
>>
>> Yeah, it can be a little hard to find, particularly the right branch :-)
>>
>> The repository is here:
>> git://git.openmoko.org/git/openmoko.git
>>
>> The branch with the latest code is origin/andy-tracking
>>
>> Finally, my HIF is here:
>> drivers/ar6000/hif/hif2.c
>
> Thanks, I've created a new page for ar6k on the wireless.kernel.org wiki so
> we don't loose track of this and so that this can be easier to find for others.
>
> http://wireless.kernel.org/en/users/Drivers/ar6k
>
> I've updated the openmoko wiki respectively:
>
> http://wiki.openmoko.org/wiki/AR6K

Hm, seems origin/andy-tracking branch is gone:

mcgrof@tux ~/devel/openmoko (git::org.openmoko.dev)$ git branch -r
  origin/HEAD -> origin/org.openmoko.dev
  origin/historic/org.openembedded.dev
  origin/historic/org.openmoko.asu.dev
  origin/historic/org.openmoko.asu.stable
  origin/historic/org.openmoko.asu.testing
  origin/org.openmoko.dev
  origin/org.openmoko.stable

Any ideas which one I should use, or is the master branch OK?

  Luis
