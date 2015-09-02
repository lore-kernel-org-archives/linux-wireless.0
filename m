Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36224 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbbIBSgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 14:36:14 -0400
Received: by ykcf206 with SMTP id f206so19443038ykc.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 11:36:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1441218485.2565.4.camel@sipsolutions.net>
References: <1440462512.2670.83.camel@perches.com> <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
 <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org> <CA+A7VXVwmDEboDq-nACJH2n-UquTkO1i-+xgEm32OD5EDVfQfg@mail.gmail.com>
 <87B673AF-9598-42D6-B77E-1F2F08A579FC@holtmann.org> <1441218485.2565.4.camel@sipsolutions.net>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Wed, 2 Sep 2015 14:35:33 -0400
Message-ID: <CA+A7VXWyzO9U8TOrzJSZtWrj2NQHZgH0vw60UZFQYtY_ffVi7A@mail.gmail.com> (sfid-20150902_203616_900099_A1AED6E9)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 September 2015 at 14:28, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-09-02 at 10:42 -0700, Marcel Holtmann wrote:
>>
>> > Any feedback or any plans to pick this for mac80211-next (which I
>> > understand is where it should go to be sent upstream)?
>>
>> I can take this through bluetooth-next tree if there are no
>> objections.
>>
>
> I'm going to to take it, but we're in the middle of release/merge
> -window time, so there was no point in doing that just yet.
>

All right, thanks for the feedback!

--
João Paulo Rechi Vita
http://about.me/jprvita
