Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57598 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3CEVta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 16:49:30 -0500
Received: by mail-qc0-f180.google.com with SMTP id v28so1275317qcm.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 13:49:29 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 16:49:29 -0500
Message-ID: <CA++BO6QA9cFmM2kU4u8ASxWqJeGwUB1385awKfXLP=O0fA87NA@mail.gmail.com> (sfid-20130305_224949_946467_3B24EA9B)
Subject: Re: mac80211: regression: fd0f979 no long authenticates w/ath9k_htc
From: Corey Richardson <corey@octayn.net>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 3:42 AM, Corey Richardson <corey@octayn.net> wrote:
> ath9k_htc driver , AR9271 (at least according to lsusb)
>
> commit fd0f979a1b67f0889aea24a7c7d2a54d6706a1cf
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Feb 7 00:14:51 2013 +0100
>
>     mac80211: simplify idle handling
>
>     Now that we have channel contexts, idle is (pretty
>     much) equivalent to not having a channel context.
>     Change the code to use this relation so that there
>     no longer is a need for a lot of idle recalculate
>     calls everywhere.
>
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> :040000 040000 85b3d4d114efb012773b4c7e1728b5bcae2e6b37
> 3ff33170763520b03e84e067f91cc0a8334e4d36 M    net
>
> any more info needed?

I noticed the mail didn't get through to all lists, perhaps the
attachments were too large? (~135K)

Files are at https://gist.github.com/cmr/a5ace41e765fca073201
