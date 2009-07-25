Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40226 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZGYBP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 21:15:58 -0400
Date: Fri, 24 Jul 2009 21:01:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: lockdep complaint , now upgraded on wireless-testing
Message-ID: <20090725010137.GA9447@tuxdriver.com>
References: <43e72e890907241743l7eb68cd9h5796e1dc70823c86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890907241743l7eb68cd9h5796e1dc70823c86@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 05:43:59PM -0700, Luis R. Rodriguez wrote:
> Pretty sure this is the same one I saw the other day when I applied
> the old netns patches from Johannes. Johannes then fixed them, but not
> sure if the new shiny patch was posted.
> 
> John, I think its best we just revert your current netns patches and
> apply Johannes' new ones. That would mean not needing my ath9k oops
> fix nor a secondary patch to fix this separately.

Where are the "Johannes' new ones"?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
