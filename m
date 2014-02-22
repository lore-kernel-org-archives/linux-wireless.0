Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:39050 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaBVATX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:19:23 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so3000366lab.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:19:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392971299.4346.20.camel@jlt4.sipsolutions.net>
References: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com>
 <CALhHN=oXr+PpiGv47sVzoi2cW_PYDME63sZ7euwtDaoVwnarTA@mail.gmail.com> <1392971299.4346.20.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:19:01 -0800
Message-ID: <CAB=NE6XgdG1==4KUpRYsqethg08Qvm_TPksq_9SG-mkwyKn2HQ@mail.gmail.com> (sfid-20140222_011927_038298_BAB8B483)
Subject: Re: [PATCH] cfg80211: regulatory, introduce NL80211_RRF_AUTO_BW rule flag
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 21, 2014 at 12:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> However, Luis, please sort out this situation, and if bits 9/10 were
> ever used by userspace (they were never used by the kernel!) then please
> submit a kernel patch that marks them as reserved in nl80211.h. The
> kernel header file should be the master file defining the API, not some
> "random" userspace tool.

Pretty sure NO-HT40 was never used (claimed bit 10), and not sure why
bit bit 9 says reserved, I'm pretty sure it never got used too.

  Luis
