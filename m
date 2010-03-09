Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:44814 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0CIAra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 19:47:30 -0500
Received: by qyk9 with SMTP id 9so5184449qyk.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 16:47:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003090934.59740.br1@einfach.org>
References: <20100308025841.7460.69949.stgit@void> <201003081317.25155.br1@einfach.org>
	<43e72e891003080824l74ecd4fbrf5a02e51c275c9b1@mail.gmail.com>
	<201003090934.59740.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Mar 2010 16:47:09 -0800
Message-ID: <43e72e891003081647r5cb0a286la5217ff1f97e0652@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 8, 2010 at 4:34 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Tuesday 09 March 2010 01:24:48 Luis R. Rodriguez wrote:
>> >> Thanks Bruno, are these stable fixes?
>> >
>> > hi luis!
>> >
>> > i think so. the behaviour before was completely broken, now it's better.
>> >
>> > but i'm not sure about that whole Cc: stable@kernel.org thing... (sorry
>> > i've been away for a while)... i read
>> > Documentation/stable_kernel_rules.txt but still not sure if that applies
>> > for this patch.
>>
>> Just add:
>>
>> Cc: stable@kernel.org
>>
>> below your Singed-off-by on the commit log entry. That list will get
>> spammed once the patch is merged on Linus' tree.
>
> i understand that.
>
> the question is more if my patch justifies bothering 'stable' or not.
>
> as i said, in my point of view ath5k has several problems right now
> (performace and stability), and i guess nobody will be using it seriously in
> actual production use (does anyone?). so i think it does not really matter if
> this or any of my other patches go into stable sooner or later. does it?

2.6.32 will be used by a lot of "enterprise" releases, I'd prefer
connection stability fixes do indeed go in for 2.6.32 for ath5k, this
seems like one. I'll let John be the judge.

  Luis
