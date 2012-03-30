Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45218 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690Ab2C3UbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 16:31:10 -0400
Received: by iagz16 with SMTP id z16so1436048iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 13:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333105904.3908.13.camel@jlt3.sipsolutions.net>
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net> <1333105904.3908.13.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Mar 2012 13:30:49 -0700
Message-ID: <CAB=NE6XXzwKjFCbV=zi7DaPtpa4aqttB4EMTqaKSzhPMHwJd1A@mail.gmail.com> (sfid-20120330_223114_777502_33956875)
Subject: Re: [PATCH 2/2] compat: explicitly export generated variables
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 4:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Doing the blanket "export" statement at the beginning
> of the generated file confuses the kernel's Makefiles
> and causes extreme build slowdowns.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Nice, how did you figure this out BTW!?

  Luis
