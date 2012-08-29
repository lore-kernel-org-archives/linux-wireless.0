Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54545 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2H2VfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 17:35:04 -0400
Received: by ieje11 with SMTP id e11so434329iej.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 14:35:02 -0700 (PDT)
Message-ID: <503E8B03.4070905@lwfinger.net> (sfid-20120829_233509_844501_D1CE4000)
Date: Wed, 29 Aug 2012 16:34:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Connolly <pjc999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com> <50365AC8.7030503@lwfinger.net> <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com> <5036660B.9020208@lwfinger.net> <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com> <50381437.7040903@lwfinger.net> <CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com> <CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com> <CAE3CJbmJ8JZzBKKJwYAL_6K_ossMK0HDCEkNLNfG-A4HzZSfzg@mail.gmail.com> <CAE3CJbm++cjK0Mf8JOsRk8vCkvKF97iw1SnJdySjc7vXUz1Qgg@mail.gmail.com>
In-Reply-To: <CAE3CJbm++cjK0Mf8JOsRk8vCkvKF97iw1SnJdySjc7vXUz1Qgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2012 04:09 PM, Patrick Connolly wrote:
> Can anyone comment on whether "iw set bitrates" should be fully
> functional using compat-wireless version 3.2.5-1 ?
>     ( if not, what do I have to do to get this to work? )

The version of compat-wireless (3.2.5) is the version of the kernel that is 
backported, and I don't think that is new enough.

If you use the version at
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5.1-1-snpc.tar.bz2, 
you should be OK.

Larry


