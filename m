Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.250]:40159 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYIPBVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 21:21:20 -0400
Received: by hs-out-0708.google.com with SMTP id 4so853693hsl.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 18:21:17 -0700 (PDT)
Message-ID: <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com> (sfid-20080916_032144_270987_41D05EBA)
Date: Mon, 15 Sep 2008 18:21:17 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Helmut Schaa" <hschaa@suse.de>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <200809151845.35841.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200809151416.07552.hschaa@suse.de>
	 <200809151634.06448.hschaa@suse.de>
	 <1221492529.10177.76.camel@localhost.localdomain>
	 <200809151845.35841.hschaa@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 9:45 AM, Helmut Schaa <hschaa@suse.de> wrote:

> Ok, I'll sum that up. Moving the policy into user space is a good thing if the
> quality values are comparable. Once mac80211 recognices a noticable quality
> change we could use IWEVQUAL to notify user space about it. Furthermore (if
> desired) the signal could be extended to not only report a value between 0
> and 100 but could also contain flags indicating lost beacons, excessive retries
> etc.

If you are going to add a new sort of notification can you please use
nl80211? No need to keep wireless extensions on life support.

  Luis
