Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59357 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaFRVuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 17:50:52 -0400
Received: by mail-pd0-f171.google.com with SMTP id fp1so1097806pdb.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 14:50:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffnZnaiTmW-CWNEjHxrUOhyHBJU8pyoBY21OQTQ=o1QgQ@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com>
 <CA+XVXfeEWB5NasJnEGXrm0aXsdhz7AZR2Az_Azv3rBbnrvatcg@mail.gmail.com>
 <CAB=NE6U=YaomArGA4VKCOv974AREw3eiTKM9U-fnjvidCDJ90g@mail.gmail.com>
 <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com>
 <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com>
 <CA+XVXfcvXEi0o-UGNu1T95+rEfpQoVZPf9oVGL3AiqgGiu-LEw@mail.gmail.com>
 <CAB=NE6Vs5y0DANeRbhU7J1z45uxENhcKDG+6b84XPxOh_f_KPw@mail.gmail.com> <CA+XVXffnZnaiTmW-CWNEjHxrUOhyHBJU8pyoBY21OQTQ=o1QgQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 14:50:31 -0700
Message-ID: <CAB=NE6Wtwxby7M8uyng_t4Hnvw7K2cU8DF4VrZ_ZV52sKnY9Fg@mail.gmail.com> (sfid-20140618_235055_631032_C86B3500)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: Arik Nemtsov <arik@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:24 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Can you propose a scenario where the new flags harm something older?

Using old userspace that does not have these flags set, the old
mechanisms are supposed to still work.

  Luis
