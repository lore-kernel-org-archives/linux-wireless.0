Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37956 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab1JFPOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 11:14:22 -0400
Received: by qadb15 with SMTP id b15so2041602qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 08:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317892545.3945.2.camel@jlt3.sipsolutions.net>
References: <1317892545.3945.2.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Oct 2011 08:13:46 -0700
Message-ID: <CAB=NE6WV3t6xZ+Fo+5xd3st3JKCAJHPGKWnk68roGjv6vNcqBA@mail.gmail.com> (sfid-20111006_171431_330894_B2A0CE17)
Subject: Re: [PATCH] compat: make driver-select only select complete lines
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 2:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Otherwise we end up enabling CONFIG_FOOBAR if
> only CONFIG_FOO is requested.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks, applied and pushed!

  Luis
