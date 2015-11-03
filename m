Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33908 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbKCRnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 12:43:04 -0500
Received: by oies66 with SMTP id s66so13136200oie.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 09:43:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446568044.29010.25.camel@sipsolutions.net>
References: <CAD1M061nR5s6MFLHtoYDk05Ewz_3SHevB6s7qTB59qz681NLUg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E8B86B4@hasmsx107.ger.corp.intel.com>
	<CAJ+vNU3u_KCOjRi1HR_f9hCi-aYYMDciR7C0+nCwJh3N6GAETQ@mail.gmail.com>
	<1446568044.29010.25.camel@sipsolutions.net>
Date: Tue, 3 Nov 2015 09:43:02 -0800
Message-ID: <CAJ+vNU1d8=Z=0j_1jaqh__830-K56MnnM=5w550+e15NveqeOg@mail.gmail.com> (sfid-20151103_184308_977053_BFA08E2D)
Subject: Re: Intel 7260 - limited in 5GHz spectrum
From: Tim Harvey <tharvey@gateworks.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Pushpal Sidhu <psidhu@gateworks.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 3, 2015 at 8:27 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-11-03 at 08:08 -0800, Tim Harvey wrote:
>>
>> Out of curiosity, can you explain what you mean about 'regulatory
>> concerns'? There are channels in the 5GHz band that can be used in
>> FCC
>> with and without DFS. Is it that certification in the 5GHz band is
>> optional and Intel didn't want to do the certification?
>>
>
> I believe the reason is that the device is sold in countries other than
> the US. Surprise! ;-)
>
> johannes

Johannes,

No surprise that its sold outside the US, but why should that mean it
should exclude 5GHz support? They all have their regulatory domains
and my understanding is that the intersection of the reg domain rules
and card capabilities should dictate if they can operate as an AP per
5GHz channel. So I'm trying to understand why this card is dropping
that capability.

Thanks,

Tim
