Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4132 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYE1M7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 08:59:08 -0400
Date: Tue, 27 May 2008 20:41:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>, JMF <tolas_feup@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Message-ID: <20080528004100.GG7779@tuxdriver.com> (sfid-20080528_145924_539786_70F658E1)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com> <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com> <loom.20080527T105701-941@post.gmane.org> <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com> <1211896423.1746.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1211896423.1746.9.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 09:53:43AM -0400, Dan Williams wrote:

> I've gotten maybe 1 or 2 requests for > 104/128-bit WEP key support for
> NM in 3 years.  Nice to have, but I'm not sure it's worth the extra code
> and maintenance burden?  Would be good to have somebody tell us what
> hardware (APs and cards) support this though.

I'm inclined to think that it is _not_ worth the trouble for this
particular feature.

John
-- 
John W. Linville
linville@tuxdriver.com
