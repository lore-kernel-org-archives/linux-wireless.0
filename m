Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3EJJeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 05:34:14 -0400
Message-ID: <1368178449.8390.10.camel@jlt4.sipsolutions.net> (sfid-20130510_113417_146793_9F883227)
Subject: Re: [PATCH 0/8] Add support for 5 and 10 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 10 May 2013 11:34:09 +0200
In-Reply-To: <20130510093241.GA28714@pandem0nium>
References: <1368170776.8390.4.camel@jlt4.sipsolutions.net>
	 <CAJ-Vmo=RCVOD1ffraTexETgqYP6LbLAa_g0d2DVd8yTO99Q1AQ@mail.gmail.com>
	 <20130510093241.GA28714@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 11:32 +0200, Simon Wunderlich wrote:

> Yes interoperability would be nice of course - I'll re-work the patchset
> to use the according half and quarter rates. Meanwhile, what do you guys think
> about enabling HT too?

I'd like to stick to the standard first. Enabling HT is nice for us, but
I'd like to see it done in a way that doesn't clash with a possible
future amendment doing it officially.

johannes

