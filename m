Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63568 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1Tm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 14:42:58 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so765330lbv.10
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 11:42:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=p11A-kA3S=ESz85OUSfHr5t+Qqka24wwbvfJuA-bksXQ@mail.gmail.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
 <20140125003418.GF28512@garbanzo.do-not-panic.com> <CALhHN=p11A-kA3S=ESz85OUSfHr5t+Qqka24wwbvfJuA-bksXQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 28 Jan 2014 11:42:37 -0800
Message-ID: <CAB=NE6VfmOMVT3zxE1iEOtT53SycgrrpiKuoi2NPuDXvccz96Q@mail.gmail.com> (sfid-20140128_204303_182672_A9BA5A59)
Subject: Re: [PATCH v2 1/3] cfg80211: add helper reg_get_regdomain() function
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 28, 2014 at 11:23 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 25 January 2014 01:34, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>> On Wed, Jan 22, 2014 at 01:43:42PM +0100, Janusz Dziedzic wrote:
>>> Add helper function that will return regdomain.
>>>
>>> +     regd = reg_get_regdomain(wiphy);
>>
>> Nice! I welcome this -- can you also add nl80211 API to expose when
>> a wiphy has its own wiphy->regd and send that to userspace too?
>>
> You mean we should introduce:
> iw wlanX reg get?

Sure, and iw dev reg get can also display what it does now but then
also iterate over all wiphys and also display all wiphy's own regd if
they have any.

> while in last_request we have only last wiphy(lr->wiphy_idx).

Right.

 Luis
