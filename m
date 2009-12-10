Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50511 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZLJNAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 08:00:22 -0500
Date: Thu, 10 Dec 2009 07:58:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, stable@kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211: Fixed bug in mesh portal paths
Message-ID: <20091210125848.GA11112@tuxdriver.com>
References: <1260412981-2982-1-git-send-email-javier@cozybit.com> <43e72e890912092220k4525d40bn680afece3e8cbb52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890912092220k4525d40bn680afece3e8cbb52@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 09, 2009 at 10:20:03PM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 9, 2009 at 6:43 PM, Javier Cardona <javier@cozybit.com> wrote:
> > Paths to mesh portals were being timed out immediately after each use in
> > intermediate forwarding nodes.  mppath->exp_time is set to the expiration time
> > so assigning it to jiffies was marking the path as expired.
> >
> > Signed-off-by: Javier Cardona <javier@cozybit.com>
> > Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> 
> Is Cc: stable@kernel.org required or does actually CC'ing
> stable@kernel.org in the patch suffice? If the patch has the CC
> embedded on the commit log I thought stable team would be notified
> upon a merge of the patch. Please correct me if I'm wrong.
> 
> Would like to verify as I'm going to be a stable whore now.

AIUI either is acceptable.  But adding the Cc line in the commit log
aids the stable team in automating their process.

In any case, sending stuff to stable@kernel.org is highly recommended
(within their guidelines, of course).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
