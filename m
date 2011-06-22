Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FVKBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 06:01:11 -0400
Subject: Re: about RCU programming
From: Johannes Berg <johannes@sipsolutions.net>
To: Manuel =?ISO-8859-1?Q?S=E1ez?= <manuelsaezr@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com> (sfid-20110622_111508_380689_0D0EB9C4)
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	 <BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	 (sfid-20110622_111508_380689_0D0EB9C4)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 12:01:09 +0200
Message-ID: <1308736869.3883.13.camel@jlt3.sipsolutions.net> (sfid-20110622_120117_369379_3255B4F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 11:15 +0200, Manuel Sáez wrote:

> and the read side:
> rcu_read_lock();
> rcu_derreference(sdata->u.ap.polling_list->sta);
> copy_sta(sdata->u.ap.polling_list->sta);
> rcu_read_unlock();
> 
> sdata->u.ap.polling_list = sdata.u.ap.polling_list->next;

This code snippet makes no sense at all. I suggest you read up on how
RCU works first.

johannes

