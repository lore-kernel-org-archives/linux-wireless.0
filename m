Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:2704 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbYLKXA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 18:00:59 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1096003rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 15:00:58 -0800 (PST)
Message-ID: <b3153e950812111500x27d3832avb99d84c13e601813@mail.gmail.com> (sfid-20081212_000109_013227_F06843C7)
Date: Thu, 11 Dec 2008 15:00:57 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b3153e950812072155t452aacb7p8ccefd1b2ec401ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 <1226944799.3902.52.camel@johannes.berg>
	 <20081118194652.GD21772@tuxdriver.com>
	 <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
	 <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com>
	 <1228554333.15939.0.camel@johannes.berg>
	 <b3153e950812062116q340c6b67l4d0c9a162d389cbf@mail.gmail.com>
	 <b6c5339f0812070619x19919c5dh62fe13085416145c@mail.gmail.com>
	 <b3153e950812072155t452aacb7p8ccefd1b2ec401ca@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did try these patches out, I have a problem, sometime, when the
card resume from suspend that I am currently tracing but still this
patch does not bring me to the same state before the suspend. If I am
currently pinging and I suspend then resumed the ping program should
resume ping as it was before suspend. I know you still working on this
but I am not sure if this what will see in final solution. The
ieee80211_notify_mac callback function was used to make sure we return
to exact state right when driver resume or driver assert and recovered
or coming from rfkill.

On Sun, Dec 7, 2008 at 9:55 PM, mohamed salim abbas
<mabbaswireless@gmail.com> wrote:
> I will review these patches and try them out.
>
> On Sun, Dec 7, 2008 at 6:19 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Sun, Dec 7, 2008 at 12:16 AM, mohamed salim abbas
>> <mabbaswireless@gmail.com> wrote:
>>> I will be happy to help if extra help need it. below is the link to the bug.
>>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1845
>>
>> Thanks Mohamed, I'd appreciate any help.  Give me a couple of days to
>> square away my current changes, then I'll post the full series.  My
>> last changeset was at:
>>
>>    http://bobcopeland.com/kernel/wl/
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>
