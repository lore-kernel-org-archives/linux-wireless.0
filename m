Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbdF0Sk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 14:40:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc: "festevam\@gmail.com" <festevam@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 21/26] iwlwifi: mvm: print base HW address during init
References: <20170625111158.1792-1-luca@coelho.fi>
        <20170625111158.1792-22-luca@coelho.fi>
        <87a84tbbsh.fsf@codeaurora.org>
        <CAOMZO5D4v1aYC4jQ=y4ci_axuaX6s8vwcvfrMcOOz7=Ph5isEA@mail.gmail.com>
        <8760fhbae6.fsf@codeaurora.org> <1498587578.22048.81.camel@intel.com>
        <1498587731.22048.83.camel@intel.com>
Date: Tue, 27 Jun 2017 21:40:52 +0300
In-Reply-To: <1498587731.22048.83.camel@intel.com> (Luciano Coelho's message
        of "Tue, 27 Jun 2017 18:22:13 +0000")
Message-ID: <878tkds28b.fsf@kamboji.qca.qualcomm.com> (sfid-20170627_204127_380098_FA10663C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

> On Tue, 2017-06-27 at 18:19 +0000, Coelho, Luciano wrote:
>> On Tue, 2017-06-27 at 20:36 +0300, Kalle Valo wrote:
>> > Fabio Estevam <festevam@gmail.com> writes:
>> > 
>> > > On Tue, Jun 27, 2017 at 2:06 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> > > 
>> > > > "crouded sniffer logs", what's that?
>> > > 
>> > > I think Luca meant 'crowded'.
>> > 
>> > Ah, makes sense. Thanks.
>> 
>> Huh, obviously a typo, sorry! Shall I fix it before my pull-req?

Up to you, I was just curious.

> And, of course, what I mean here is that sometimes you get sniffer logs
> from very crowded areas with gazillions of different MAC addresses. 
> This way we can match the logs with the sniffer a bit more easily.

Hehe, I thought you referred to "crowdsourcing" :)

-- 
Kalle Valo
