Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1KYHe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 02:34:59 -0500
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way
 similar to rx agg sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALGY4ftKV_u0avbXytHOxRWWiDiDBGhAKTCE+_QqJnebt8Rj=Q@mail.gmail.com> (sfid-20111125_054407_814873_ADCC84EF)
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	 <1322158678.5366.27.camel@jlt3.sipsolutions.net>
	 <CALGY4fv6NTRDPUEa-7h+DqaHZwdKnNG4fEmzyHrYZukz3B1gqA@mail.gmail.com>
	 <1322159944.5366.42.camel@jlt3.sipsolutions.net>
	 <CALGY4ftKV_u0avbXytHOxRWWiDiDBGhAKTCE+_QqJnebt8Rj=Q@mail.gmail.com>
	 (sfid-20111125_054407_814873_ADCC84EF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 08:34:56 +0100
Message-ID: <1322206496.4123.0.camel@jlt3.sipsolutions.net> (sfid-20111125_083502_571337_D27FCC48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-24 at 23:43 -0500, Nikolay Martynov wrote:

> >> > Looks OK to me. Did you run it through sparse too? :-)

>   I wasn't able to find any sparse warnings introduced by my changes,
> everything looks fine.

Great, thanks for checking.

johannes

