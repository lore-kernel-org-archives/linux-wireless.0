Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdDRMaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 08:30:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-13
References: <1492086857.31741.20.camel@coelho.fi>
        <87lgqy6x6n.fsf@codeaurora.org> <87h91m6w6f.fsf@qca.qualcomm.com>
        <1492503743.31741.35.camel@coelho.fi>
Date: Tue, 18 Apr 2017 15:30:08 +0300
In-Reply-To: <1492503743.31741.35.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 18 Apr 2017 11:22:23 +0300")
Message-ID: <87bmrtc2zz.fsf@kamboji.qca.qualcomm.com> (sfid-20170418_143020_200407_E4A74F89)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Tue, 2017-04-18 at 06:56 +0000, Kalle Valo wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>> 
>> > Luca Coelho <luca@coelho.fi> writes:
>> > 
>> > >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
>> > > tags/iwlwifi-next-for-kalle-2017-04-13
>> > > 
>> > > for you to fetch changes up to 87d0e1af9db3bff4ec2f68fd4d032f89c23867a4:
>> > > 
>> > >   iwlwifi: mvm: separate queue mapping from queue enablement
>> > > (2017-04-11 15:25:00 +0300)
>> > > 
>> > > ----------------------------------------------------------------
>> > > Patches intended for v4.12:
>> > > 
>> > >   * Some small fixes here and there;
>> > >   * The usual cleanups and small improvements;
>> > >   * Work to support A000 devices continues;
>> > >   * New FW API version;
>> > >   * Some debugging improvements;
>> > > 
>> > > ----------------------------------------------------------------
>> > 
>> > This one has few conflicts. I can fix those manually, but can you give
>> > some guidance how?
>> 
>> I think I got it now, see below for the diff I did. Can you please
>> check that?
>> 
>> The resolution is also in the pending branch:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=pending
>
>
> Yes, looks good! Thanks for resolving it and sorry for not foreseeing it
> to give you a heads up.

Good, thanks. I pushed it to master branch now.

-- 
Kalle Valo
