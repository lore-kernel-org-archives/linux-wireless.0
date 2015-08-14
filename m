Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35740 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbHNSFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 14:05:46 -0400
Received: by oiew67 with SMTP id w67so29795412oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 11:05:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439414913.15847.1.camel@sipsolutions.net>
References: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com>
 <1439413727.15847.0.camel@sipsolutions.net> <CAF7g2RGORavCuvoYzese0usNatsie5tjyN_7J_JgFDK9zurzLQ@mail.gmail.com>
 <1439414913.15847.1.camel@sipsolutions.net>
From: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Date: Fri, 14 Aug 2015 11:05:05 -0700
Message-ID: <CAF7g2RFfcrJD6M8oGKF3E-a4+fehdCOC=ocxdnDVww0nBiaPfQ@mail.gmail.com> (sfid-20150814_200551_302941_CCAB5604)
Subject: Re: iw coalesce show - disabled at init?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2015 at 2:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-08-12 at 14:13 -0700, Kobi Cohen-Arazi wrote:
>>
>> So what you're saying is that at startup, drivers should have
>> coalesce _disabled_ (i.e. no rules for coalesce) ?
>>
>
> I think so, yes. It's a service that should be actively enabled, with
> user-configured rules. Mechanism vs. policy, and all that ...

I think that in most (if not all) NICs, this specific service is
enabled by default.

Kobi
