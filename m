Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:12257 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZFBVDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 17:03:23 -0400
Received: by qw-out-2122.google.com with SMTP id 5so5798689qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 14:03:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0906021357y14c64003lbbfaa0744ced7617@mail.gmail.com>
References: <1243974656-15600-1-git-send-email-lrodriguez@atheros.com>
	<b6c5339f0906021357y14c64003lbbfaa0744ced7617@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 2 Jun 2009 14:03:04 -0700
Message-ID: <43e72e890906021403i541d7413w77c2dd2d18c92b1f@mail.gmail.com>
Subject: Re: [PATCH] ath: make regulatory parsing more verbose on debug
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2009 at 1:57 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Jun 2, 2009 at 4:30 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> This should help when reviewing issues regarding regulatory
>> domain on ath5k/ath9k/ar9170.
>
> i.e. code is too complicated to reason about :)

Heh yeah, hey we can revert back to the old HAL regulatory code if you
like, did you ever get the pleasure to look at that?

  Luis
