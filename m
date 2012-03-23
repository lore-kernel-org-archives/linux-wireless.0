Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57173 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2CWRZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 13:25:53 -0400
Message-ID: <1332524036.5884.11.camel@sortiz-mobl> (sfid-20120323_182556_536840_B159CC95)
Subject: Re: [PATCH] NFC: Add Core support to generate tag lost event
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Ilan Elias <ilane@ti.com>
Cc: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Date: Fri, 23 Mar 2012 18:33:56 +0100
In-Reply-To: <CAK3JMAZhJP=RC09gA7jHf7Z5ZhuscHbsLW2dPq9Wk52uGQt7YA@mail.gmail.com>
References: <4F6C5C59.2060708@linux.intel.com>
	 <CAK3JMAZhJP=RC09gA7jHf7Z5ZhuscHbsLW2dPq9Wk52uGQt7YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro,

On Fri, 2012-03-23 at 14:11 -0300, Lauro Ramos Venancio wrote:
> 2012/3/23 Eric Lapuyade <eric.lapuyade@linux.intel.com>:
> > Some HW/drivers get notifications when a tag moves out of the radio field.
> > This notification is now forwarded to user space through netlink.
> 
> I think to put a timer in the NFC core is not the best solution for
> this problem.
> This solution is not suitable for devices that receive an event when
> the tag moves out of the field.
I don't know of such device. HCI based devices don't get such event,
neither does the pn53x USB ones.
Ilan, does NCI provide such event ?

Cheers,
Samuel.


