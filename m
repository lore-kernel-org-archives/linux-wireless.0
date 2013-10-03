Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62863 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3JCKHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 06:07:44 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so8645564wid.8
        for <linux-wireless@vger.kernel.org>; Thu, 03 Oct 2013 03:07:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1380612524.14430.0.camel@jlt4.sipsolutions.net>
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
	<1380532074.14467.2.camel@jlt4.sipsolutions.net>
	<20130930203206.GM10994@tuxdriver.com>
	<1380612524.14430.0.camel@jlt4.sipsolutions.net>
Date: Thu, 3 Oct 2013 12:07:43 +0200
Message-ID: <CA+icZUVf1A2+-LPEARpOnRShm2BXagtHtw7+SidTs2b_ifV97A@mail.gmail.com> (sfid-20131003_120748_225909_81D2FBC2)
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 1, 2013 at 9:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-09-30 at 16:32 -0400, John W. Linville wrote:
>> On Mon, Sep 30, 2013 at 11:07:54AM +0200, Johannes Berg wrote:
>> > On Mon, 2013-09-30 at 11:02 +0200, Johannes Berg wrote:
>> > > From: Johannes Berg <johannes.berg@intel.com>
>> > >
>> > > The merge b35c8097 seems to have lost commit eabc4ac5d,
>> > > put the code back.
>> > >
>> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Ah, forgot to say - John, I think you should apply this as a patch,
>> > having it in my pull request seems odd. But if you're of another opinion
>> > I can stick it into my next -next pull request too.
>>
>> OK -- does this need to be treated as a fix?  Or is -next OK?
>
> I believe the merge damage only occurred during merging wireless.git (or
> one of its upstreams) into wireless-next.git.
>

Hmm, this patch applies also for Linux v3.12-rc3+, so you are sure it
is not for iwlwifi-3.12-fixes?

- Sedat -
