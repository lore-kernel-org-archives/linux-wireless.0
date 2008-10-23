Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53408 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYJWO6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 10:58:39 -0400
Date: Thu, 23 Oct 2008 10:55:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, johannes@sipsolutions.net,
	tomasw@gmail.com, Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH v3] mac80211: Re-enable aggregation
Message-ID: <20081023145102.GA5816@tuxdriver.com> (sfid-20081023_165843_352872_3053938F)
References: <18685.37489.577735.596008@gargle.gargle.HOWL> <43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 08:10:42PM -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 21, 2008 at 1:27 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > Wireless HW without any dedicated queues for aggregation
> > do not need the ampdu_queues mechanism present right now
> > in mac80211. Since mac80211 is still incomplete wrt TX MQ
> > changes, do not allow aggregation sessions for drivers that
> > set ampdu_queues.
> >
> > This is only an interim hack until Intel fixes the requeue issue.
> >
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > Signed-off-by: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
> 
> Poke.

Just waiting to see comments from those who understand aggregation
better than I do...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
