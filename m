Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:36731 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaEFLoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 07:44:30 -0400
Received: by mail-qc0-f179.google.com with SMTP id x3so5990820qcv.10
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2014 04:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399358996.4218.0.camel@jlt4.sipsolutions.net>
References: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com>
	<1399358996.4218.0.camel@jlt4.sipsolutions.net>
Date: Tue, 6 May 2014 13:44:29 +0200
Message-ID: <CALDuf6iCmceJG1kGsJgii8oe65ivnQEsAgqPZ_LTAHoGo0OPZg@mail.gmail.com> (sfid-20140506_134433_582987_A65819AB)
Subject: Re: [PATCH 1/2] mac80211: add no update durationId bit in radiotap
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I can achieve the same result without changing radiotap header if
durationID filed won't be updated for all injected frames. What do you
think about it?

Best regards,
Marek Kwaczynski

On 6 May 2014 08:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-05-06 at 08:32 +0200, Marek Kwaczynski wrote:
>> Adds a new bit in radiotap_tx flags, which allows injections
>> frames without changing durationId filed. The intention is
>> a NAV update testing.
>
> NACK.
>
> http://www.radiotap.org/suggested-fields/TX%20flags
>
> And since I'm tired of this, I'll make any further radiotap updates to
> this particular field contingent on somebody actually standardising it
> properly.
>
> johannes
>
