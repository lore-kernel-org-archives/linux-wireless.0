Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55334 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3EMD4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 23:56:32 -0400
Received: by mail-qc0-f177.google.com with SMTP id e1so3072556qcy.8
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 20:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com>
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
 <518DF4B1.3020706@broadcom.com> <518ECC39.9090401@gmail.com> <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com>
From: JoSH Lehan <krellan@gmail.com>
Date: Sun, 12 May 2013 20:56:11 -0700
Message-ID: <CALOB5Qbx-kPzEcN32i9Fo3Ac7L6Dp9erAZgLyyh0f7Mn0m+-fw@mail.gmail.com> (sfid-20130513_055636_143955_0462258E)
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
To: Adrian Chadd <adrian@freebsd.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 11, 2013 at 5:46 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> No, you or the vendor should forward port it to linux-next, then you
> can just pick up the whole driver/framework set from compat-wireless.

For my needs, I can use the entire set of wireless drivers from
compat-drivers, plus the vt6656 and rtl8712 drivers.

If I were to undertake the task of porting the vt6656/rtl8712 vendor
tarballs to linux-next, so that I could integrate them into
compat-drivers and then build everything compatibly, I wonder if it
would be worth trying to improve what's in staging?

Ideally, I'd need to do some big three-way merge: the current contents
of staging, the original code drop that went into staging, and the
current versions of vendor tarballs.  Would such a thing be practical?
 It would be quite a project, and I would be hoping the results of it
would be accepted into staging.  It might help others, as well.  Since
compat-drivers only pulls from the regular kernel driver directory and
not from staging, it wouldn't help get them into compat-drivers,
though.

Josh Lehan
