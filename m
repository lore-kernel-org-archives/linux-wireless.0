Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaC1NGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:06:44 -0400
Message-ID: <1396012002.4175.24.camel@jlt4.sipsolutions.net> (sfid-20140328_140650_090390_497A450A)
Subject: Re: [PATCH v2 05/13] mac80211: track assigned vifs in chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:06:42 +0100
In-Reply-To: <1395409651-26120-6-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145337_759223_1DDA0FA6)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-6-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145337_759223_1DDA0FA6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> This can be useful.

That's a bit terse :)

Can you add a comment for locking?

johannes

