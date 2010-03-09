Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56777 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0CIDcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 22:32:53 -0500
Received: by pvb32 with SMTP id 32so1687322pvb.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 19:32:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1003081910t745c3e5ftafbedd1298487875@mail.gmail.com>
References: <20100308025841.7460.69949.stgit@void> <201003090934.59740.br1@einfach.org>
	<43e72e891003081647r5cb0a286la5217ff1f97e0652@mail.gmail.com>
	<201003090950.21811.br1@einfach.org> <43e72e891003081721h3db9ca53n4a3688ca8aa452a4@mail.gmail.com>
	<b6c5339f1003081910t745c3e5ftafbedd1298487875@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Mar 2010 19:32:33 -0800
Message-ID: <43e72e891003081932h49340b6aia3fb6fd1e60ae8d7@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
To: Bob Copeland <me@bobcopeland.com>
Cc: Bruno Randolf <br1@einfach.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 8, 2010 at 7:10 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Mar 8, 2010 at 8:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Mon, Mar 8, 2010 at 4:50 PM, Bruno Randolf <br1@einfach.org> wrote:
>
>>>> > as i said, in my point of view ath5k has several problems right now
>>>> > (performace and stability), and i guess nobody will be using it seriously
>>>> > in actual production use (does anyone?).
>
> Yes, people do use ath5k in production.  Some large companies.
>
>>>> 2.6.32 will be used by a lot of "enterprise" releases, I'd prefer
>>>> connection stability fixes do indeed go in for 2.6.32 for ath5k
>
>>> sure, as i said, i don't mind. :)
>>
>> Alright lets skip stable for this.
>
> Wow this whole line of conversation is confusing :)

Hehe. sorry well I was talking to Bruno about the "stable"
qualifications of this fix, and it doesn't fix an oops or serious bug,
but it certainly can improve performance but I haven't myself seen
numbers and would hate to justify just about pushing anything
upstream.

> If this fixes a calibration bug it needs to go to stable.

Perhaps a little more elaboration on the commit log on the impact and
how this helps and how much would help.

  Luis
