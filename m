Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:38688 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZHRSZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:25:18 -0400
Received: by ywh3 with SMTP id 3so5440042ywh.22
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:25:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250619585.4742.1929.camel@desktop>
References: <445f43ac0908181108g490934c1ib0c805859cba1e44@mail.gmail.com>
	 <1250618340-32129-1-git-send-email-javier@cozybit.com>
	 <1250619585.4742.1929.camel@desktop>
Date: Tue, 18 Aug 2009 11:25:18 -0700
Message-ID: <445f43ac0908181125v6b1f4e2rc7ac511ae4a6c951@mail.gmail.com>
Subject: Re: [PATCH] mac80211: New stat counters for multicast and unicast
	forwarded frames
From: Javier Cardona <javier@cozybit.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	andrey@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel,

On Tue, Aug 18, 2009 at 11:19 AM, Daniel Walker<dwalker@fifo99.com> wrote:
> On Tue, 2009-08-18 at 10:59 -0700, Javier Cardona wrote:
>> From: Daniel Walker <dwalker@fifo99.com>
>>
>> This expands on the current fwded_frames stat counter which should be equal to
>> the total of these two new counters.  The new counters are called "fwded_mcast"
>> and "fwded_unicast".
>>
>> Signed-off-by: Daniel Walker <dwalker@fifo99.com>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> ---
>
> Might have been nice for you to wait for me to review the new version
> before adding my sign off , but it looks fine.

You are right.  Sorry for that.

Thanks,

Javier
