Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55307.mail.re4.yahoo.com ([206.190.58.186]:20404 "HELO
	web55307.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751774Ab0ATOwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 09:52:31 -0500
Message-ID: <856792.42713.qm@web55307.mail.re4.yahoo.com>
Date: Wed, 20 Jan 2010 06:45:50 -0800 (PST)
From: X Xiao <austinxxh-linux@yahoo.com>
Reply-To: austinxxh-linux@yahoo.com
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses.
To: Benoit Papillault <benoit.papillault@free.fr>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1263982869.14538.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

What do you mean by saying "on its own the patch is wrong".

Thanks,
xxiao

--- On Wed, 1/20/10, Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes@sipsolutions.net>
> Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses.
> To: "Benoit Papillault" <benoit.papillault@free.fr>
> Cc: linux-wireless@vger.kernel.org
> Date: Wednesday, January 20, 2010, 4:21 AM
> On Tue, 2010-01-19 at 17:42 +0100,
> Benoit Papillault wrote:
> > The same code is also used for probe request
> generation
> 
> The code is probably fine, but on its own the patch is
> wrong, so we
> shouldn't merge it.
> 
> johannes
> 
