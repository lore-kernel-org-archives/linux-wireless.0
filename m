Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:61916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYKCPRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 10:17:05 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2628480rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 07:17:04 -0800 (PST)
Message-ID: <b6c5339f0811030717mfa8ac56hdd58c367563ed931@mail.gmail.com> (sfid-20081103_161710_755671_D91CF1A5)
Date: Mon, 3 Nov 2008 10:17:04 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Dan Williams" <dcbw@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811022052n8c5e7d3ic722caa65c711481@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
	 <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
	 <43e72e890811022043t5525d924vcb776569a7bebbc8@mail.gmail.com>
	 <43e72e890811022049l386789f5qf8bde98eedcd4d2c@mail.gmail.com>
	 <43e72e890811022052n8c5e7d3ic722caa65c711481@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 11:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> Sorry, my fault, this was a direct result of
>>>> 60c7e22196fb4230b76db1f5fb283e811b8f3fb3 "ath5k: honor
[...]
> OK Vasanth confirmed this is correct, and ath9k actually has incorrect
> behavior so we have to fix that there as well. If stable got the ath5k
> changes to the filter then yes we should push it there too.

Heh, yeah I thought the hardware was doing magic on our behalf too; I
guess I should've asked about ath9k rather than assume it was right
and ath5k was wrong.

I don't think the change got submitted for stable and it only went for
rc3 a day or two ago.  John, can you revert
60c7e22196fb4230b76db1f5fb283e811b8f3fb3 or take Luis' patch which
effectively does the same?

-- 
Bob Copeland %% www.bobcopeland.com
