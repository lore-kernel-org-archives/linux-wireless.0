Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1GOSg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 14:36:56 -0400
Received: by wyg8 with SMTP id 8so991915wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 11:36:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310723140.4164.10.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-2-git-send-email-thomas@cozybit.com>
	<1310723140.4164.10.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jul 2011 11:36:54 -0700
Message-ID: <CAG6hwVP4pGonXgJwoRYgG0yRgPXZVOR54PvcC2-oCkMPWu14eQ@mail.gmail.com> (sfid-20110715_203659_011568_17AFCD7B)
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
>
>> Based on Javier Cardona's "mac80211: Support beacon configuration via
>> nl80211 for mesh interfaces", which never made it upstream.
>
> Ok I don't get it -- this patchset seems to apply fine, so what part is
> dependent on Javier's patches?

"derived from" would have been much more accurate wording.

>
> johannes
>
>
