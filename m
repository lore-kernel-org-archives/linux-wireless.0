Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1J1IJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:09:32 -0400
Subject: Re: [wireless-next PATCH 2/5] wifi: Support disabling ht40.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319778680-11405-2-git-send-email-greearb@candelatech.com> (sfid-20111028_071139_530762_135DB41A)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071139_530762_135DB41A)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:09:30 +0200
Message-ID: <1319789370.3914.11.camel@jlt3.sipsolutions.net> (sfid-20111028_100936_714241_254914EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:

>  struct vif_params {
>  	int use_4addr;
>  	int disable_11n;
> +	int disable_ht40;
>  };

All the comments on patch 1 apply -- per connection parameter,
capability flag etc.

I do wonder if it would be worthwhile to make it a u32 "connection
flags" or so instead of defining them separately.

johannes

