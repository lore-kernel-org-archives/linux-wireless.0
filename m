Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:17367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYHFWih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 18:38:37 -0400
Received: by rv-out-0506.google.com with SMTP id k40so145877rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 15:38:37 -0700 (PDT)
Message-ID: <1ba2fa240808061538l1e1d7a70x11ef7143ec9d2ea5@mail.gmail.com> (sfid-20080807_003840_852353_3CD52EE0)
Date: Thu, 7 Aug 2008 01:38:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: split out aggregation code
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218051603.23048.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1218051603.23048.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 6, 2008 at 10:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> It's more manageable that way. Also move some constants to
> include/linux/ieee80211.h.

I'm not sure this is good point of time to do that. Aggregation is not
working on 2.6.27 and we want to fix it there.
Splitting now will just complicate the effort.

> + *
> + * Copyright 2002-2005, Instant802 Networks, Inc.
 > + * Copyright 2005-2006, Devicescape Software, Inc.
> + * Copyright 2006-2007  Jiri Benc <jbenc@suse.cz>

If you separating this file then remove these 3 above

> + * Copyright 2008       Ron Rindjunsky <ron.rindjunsky@intel.com>
You would probably want to add this one as the major copyright.
> + * Copyright 2008       Johannes Berg <johannes@sipsolutions.net>
Thanks
Tomas
