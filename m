Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46061 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaBSA0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:26:42 -0500
Received: by mail-lb0-f173.google.com with SMTP id s7so11413170lbd.32
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:26:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392201773.4146.10.camel@jlt4.sipsolutions.net>
References: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com> <1392201773.4146.10.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 16:26:20 -0800
Message-ID: <CAB=NE6WtrrdkoeQuBrzhYLQqeckJ3E9RC-z4d_g5-9GJM47PJw@mail.gmail.com> (sfid-20140219_012645_479795_9EF4891D)
Subject: Re: [PATCH] cfg80211: bugfix in regulatory user hint process
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Inbal Hacohen <Inbal.Hacohen@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 2:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> After processing hint_user, we would want to schedule the
>> timeout work only if we are actually waiting to CRDA. This happens
>> when the status is not "IGNORE" nor "ALREADY_SET".
>
> Luis, does this seem right to you? I looked at it but wasn't _entirely_
> sure.

Looks good to me as well.

  Luis
