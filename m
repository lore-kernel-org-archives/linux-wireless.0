Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34940 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaETJzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 05:55:20 -0400
Received: by mail-lb0-f181.google.com with SMTP id q8so182901lbi.26
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 02:55:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com>
 <CA+XVXfeEWB5NasJnEGXrm0aXsdhz7AZR2Az_Azv3rBbnrvatcg@mail.gmail.com>
 <CAB=NE6U=YaomArGA4VKCOv974AREw3eiTKM9U-fnjvidCDJ90g@mail.gmail.com> <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 02:54:58 -0700
Message-ID: <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com> (sfid-20140520_115524_043758_4DB3B100)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: Arik Nemtsov <arik@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 2:25 AM, Arik Nemtsov <arik@wizery.com> wrote:
>
> Why won't old regdb rules work? The NL80211_RRF_NO_160MHZ for instance
> is not used anywhere in old or new regdbs.
> So all the new code in reg_get_max_bandwidth is ignored in current or
> older crda/regdb flows.
>
> What am I missing?

It will also be ignored on newer kernels using old wireless-regdb.

 Luis
