Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58196 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1JFPNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 11:13:38 -0400
Received: by qyk7 with SMTP id 7so2674513qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 08:13:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317890726.3945.0.camel@jlt3.sipsolutions.net>
References: <1317890726.3945.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Oct 2011 08:12:48 -0700
Message-ID: <CAB=NE6U8OQh_jYVvXjvb5iY8XCHOe9=baFUaH_yNv+cJvM1R6Q@mail.gmail.com> (sfid-20111006_171343_113565_C1FF7D66)
Subject: Re: [PATCH] compat: fix warning in alloc_netdev_mqs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 1:45 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Depending on the arguments to alloc_netdev_mqs(),
> it may give a warning due to the use of max().
> Fix the warning with max_t().
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks, applied and pushed!

  Luis
