Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53513 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZEZNa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:30:29 -0400
Date: Tue, 26 May 2009 15:15:38 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v11] rfkill: rewrite
Message-ID: <20090526131533.GA3932@tuxdriver.com>
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A1BDE51.7020009@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 08:19:29AM -0400, Will Keaney wrote:
> Johannes Berg wrote:
> > This patch completely rewrites the rfkill core to address
> > the following deficiencies:
> >   
> I applied this to a fresh pull of wireless-testing this morning, and
> haven't had any problems from it.  It looks like the soft lockup I
> reported earlier has been fixed.

Cool, thanks for the report.

I'm leaning towards merging this in time for the 2.6.31 merge
window...who wants to complain? :-)

John

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
