Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1JVUAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 16:00:36 -0400
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319313081-28722-1-git-send-email-guy@wizery.com> (sfid-20111022_215339_003667_2685C94A)
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
	 (sfid-20111022_215339_003667_2685C94A)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 22:00:32 +0200
Message-ID: <1319313632.24918.0.camel@jlt3.sipsolutions.net> (sfid-20111022_220040_852878_C13BA571)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 21:51 +0200, Guy Eilam wrote:

> +/**
> + * enum nl80211_probe_resp_offload_support_attr - definition of optional
> + *	supported protocols for probe response offloading by the driver/firmware
> + *	to be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT
> + *	attribute. Each enum value represents a bit in the bitmap of
> + *	supported protocols.

Oops I should have pointed that out before -- that's not valid
kernel-doc.

Also, maybe this should say how it'll be supported (i.e. by passing the
frame up for userspace to reply to, I think?)

johannes

