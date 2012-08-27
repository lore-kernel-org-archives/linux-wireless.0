Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36968 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2H0Oyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:54:33 -0400
Received: by ialo24 with SMTP id o24so8331679ial.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 07:54:33 -0700 (PDT)
Message-ID: <503B8A25.9010001@lwfinger.net> (sfid-20120827_165437_827168_53D8B5DF)
Date: Mon, 27 Aug 2012 09:54:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Connolly <pjc999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com> <50365AC8.7030503@lwfinger.net> <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com> <5036660B.9020208@lwfinger.net> <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com> <50381437.7040903@lwfinger.net> <CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com> <CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
In-Reply-To: <CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2012 08:50 AM, Patrick Connolly wrote:
> So can anybody comment on whether kernel 2.6.32 is recent enough to
> support "iw" version 0.9.22 ?

It is not; however, you can build compat-wireless for that kernel and get code 
that will.

Larry


