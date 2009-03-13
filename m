Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56897 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZCMS3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 14:29:05 -0400
Received: by ewy25 with SMTP id 25so2666777ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 11:29:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0903131123h4cb6379k472166ff81b9c5f2@mail.gmail.com>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
	 <1236893111.30325.10.camel@maxim-laptop>
	 <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com>
	 <b6c5339f0903121433r7bbf2dd8l484d15446241dccd@mail.gmail.com>
	 <1236895489.17849.3.camel@maxim-laptop>
	 <1236940708.4708.14.camel@maxim-laptop>
	 <b6c5339f0903131123h4cb6379k472166ff81b9c5f2@mail.gmail.com>
Date: Fri, 13 Mar 2009 20:29:01 +0200
Message-ID: <40f31dec0903131129m47002de1g792b427be524995b@mail.gmail.com> (sfid-20090313_192908_644379_021ADF60)
Subject: Re: [ath5k-devel] Thanks for TX power patch
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mick@madwifi-project.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/13 Bob Copeland <me@bobcopeland.com>:
> On Fri, Mar 13, 2009 at 6:38 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>>
>> Just compiled and installed latest wireless-testing with Nick's patches,
>> and your patch.
>>
>> System is rock solid, module reload/s2disk/s2ram/long transfers work
>> just fine.
>
> Great, thanks for the test!
>
> --
> Bob Copeland %% www.bobcopeland.com

Cool, nice catch Bob ;-)

I'll resubmit the patches on the weekend and address this bug and
Jiri's comments...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
