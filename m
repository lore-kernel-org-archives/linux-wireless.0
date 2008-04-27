Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:56058 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYD0PAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 11:00:06 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7284036waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 08:00:05 -0700 (PDT)
Message-ID: <1ba2fa240804270800t15c02830p56470fa8996b50d3@mail.gmail.com> (sfid-20080427_170042_719660_BBBCD27B)
Date: Sun, 27 Apr 2008 18:00:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: incorrect shift direction
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1209295470.10943.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209293320.14173.63.camel@brick>
	 <1209295470.10943.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2008 at 2:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-04-27 at 03:48 -0700, Harvey Harrison wrote:
>  > Looks like  5d2cdcd4e85c5187db30a6b29f79fbbe59f39f78 got the
>  > shifts wrong.
>
>  Aha! Thanks for tracking this down. We had a patch to fix this but were
>  confused why the bug hadn't been noticed before. So it looks like it
>  wasn't *present* before :)
>
What to say.... Shame on me.
Tomas
