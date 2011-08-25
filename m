Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39911 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1HYSbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 14:31:13 -0400
Received: by pzk37 with SMTP id 37so2871799pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 11:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110825114536.GA11153@tuxdriver.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
 <87ei09onhi.fsf@purkki.adurom.net> <20110825114536.GA11153@tuxdriver.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Aug 2011 11:30:53 -0700
Message-ID: <CAPjQAd991sJkgNmpnKvANGAVx3KN6K4dpdt8WdZ2H=8MGYz-yg@mail.gmail.com> (sfid-20110825_203116_910780_A4D25504)
Subject: Re: [PATCH 0/8] FIXUP: mesh gates
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 4:45 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Aug 25, 2011 at 12:21:29PM +0300, Kalle Valo wrote:
>> Thomas Pedersen <thomas@cozybit.com> writes:
>>
>> > Since v1 of the mesh gate series was accidentally applied, revert
>> > the relevant v1s and apply the v2s.
>>
>> This looks ugly in the git history. IMHO it would be cleaner that you
>> would do a diff between series v1 and v2 and submit that as a proper
>> patch.
>>
>> But John might think otherwise, better to wait for his comment.
>
> That is how I would prefer it as well.

As a general rule, should we treat patchsets sent to the list
atomically?  I.e. if there are objections to a few patches in the set,
should we resubmit a v2 of the whole patchset?
(Before asking I tried to find that info here:
http://linuxwireless.org/en/developers/Documentation/SubmittingPatches
. I'll be happy to update the wiki with your response if you think
it's relevant)

Cheers,

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
