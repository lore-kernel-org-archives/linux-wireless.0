Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYKLPz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 10:55:29 -0500
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 10:53:25 -0500
Message-Id: <1226505205.13536.13.camel@localhost.localdomain> (sfid-20081112_165534_352624_6D71A00D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-11 at 16:32 -0800, Luis R. Rodriguez wrote:
> By default do we want users of compat-wireless to get libertas_usb or
> libertas_tf? Both drivers are for Marvell Libertas 8388 USB 802.11b/g
> cards so we need to pick one.

I think libertas_tf is still experimental at this time.  Louis could
elaborate more.

Dan


