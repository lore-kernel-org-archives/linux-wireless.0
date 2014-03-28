Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1NLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:11:16 -0400
Message-ID: <1396012272.4175.27.camel@jlt4.sipsolutions.net> (sfid-20140328_141120_033765_2579CE98)
Subject: Re: [PATCH v2 12/13] mac80211: compute chanctx refcount on-the-fly
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:11:12 +0100
In-Reply-To: <1395409651-26120-13-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145348_783692_069A202E)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-13-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145348_783692_069A202E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> It doesn't make much sense to store refcount in
> the chanctx structure. One still needs to hold
> chanctx_mtx to get the value safely. Besides,
> refcount isn't on performance critical paths.
> 
> This will make implementing chanctx reservation
> refcounting a little easier.

Why bother with patch 11 then?

johannes

