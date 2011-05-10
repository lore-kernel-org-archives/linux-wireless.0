Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48565 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1EJWIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 18:08:16 -0400
Received: by qwk3 with SMTP id 3so3931716qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 15:08:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimecZ0uB4V_b-8F784Tnbkqo71ORA@mail.gmail.com>
References: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
	<BANLkTimecZ0uB4V_b-8F784Tnbkqo71ORA@mail.gmail.com>
Date: Wed, 11 May 2011 00:08:15 +0200
Message-ID: <BANLkTinfMbkyh9kB+hsmka-JcWXAYEPynw@mail.gmail.com> (sfid-20110511_000819_813755_2E680FBF)
Subject: Re: [PATCH V2 0/3] ssb/b43(legacy): clean dangling cores workarounds
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 8 maja 2011 19:54 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> W dniu 8 maja 2011 20:30 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
>> There is no perfect place for this workarounds, but keeping it in ssb sounds
>> more reasonable.
>
> Uups, I didn't save edition fixing this grammatical mistake. I'm lucky
> it won't be visible anywhere in git log :)

John: something went wrong there. You applied b43 and b43legacy
patches, but they should applied *after* ssb patch I don't see in your
tree.

I don't know how many people can be affected by this... Can not tell
you if we should rebase or just commit ssb patch quickly.

-- 
Rafał
