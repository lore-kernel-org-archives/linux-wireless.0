Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22392 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1HYOmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 10:42:11 -0400
Date: Thu, 25 Aug 2011 10:42:05 -0400
From: Pavel Roskin <proski@gnu.org>
To: pangyunong <029012@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] is nl80211 being used now?
Message-ID: <20110825104205.26db0156@mj> (sfid-20110825_164232_427799_EF7ABAF8)
In-Reply-To: <1312996191.4057.12.camel@Yunong>
References: <1312996191.4057.12.camel@Yunong>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 11 Aug 2011 01:09:51 +0800
pangyunong <029012@gmail.com> wrote:

> Hi all,
>  I see something in
> http://linuxwireless.org/en/developers/Documentation/nl80211
> 
> it said nl80211 still be under development. does the current version
> we use use nl80211 already?

You are writing to a wrong mailing list.  The ath9k-devel list is
about specific hardware from Atheros.  This question belongs to the list
about Linux wireless subsystem, linux-wireless@vger.kernel.org, so I'm
copying your message there.

Yes, nl80211 is used by all drivers supporting cfg80211, which includes
mac80211 based drivers and some other drivers (orinoco, I believe,
although it's not supported well).

The wording on the nl80211 page needs fixing, as it leaves a wrong
impression that nl80211 is some new immature project.  But the actual
text is probably correct.  nl80211 is new, it's developed, it's a
replacement for Wireless Extensions.

Unfortunately, I don't have enough knowledge of the state of nl80211 to
rewrite the page.  But it needs to be improved.

-- 
Regards,
Pavel Roskin
