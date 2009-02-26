Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:30688 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745AbZBZX3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:29:23 -0500
Received: by wf-out-1314.google.com with SMTP id 28so888748wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2009 15:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com>
References: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com>
Date: Thu, 26 Feb 2009 15:29:22 -0800
Message-ID: <43e72e890902261529k5b31537ctbb6426cd260154a7@mail.gmail.com> (sfid-20090227_002937_088490_0B78849A)
Subject: Re: [PATCH v2 0/3] cfg80211: send regulatory events
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 3:23 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This series does the work to prep and then send regulatory
> events to userspace. This v2 keeps the country IE environment
> within cfg80211.h as we don't want to inform userspace about
> details of the country IE. We also now add the defines to help
> userspace determine when the kernel has the new command request
> and attributes.

I forgot to mention this is also no longer based on top of Jouni's
MLME patch as that will be resent later so this can go in first.

  Luis
