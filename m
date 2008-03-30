Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2131 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYC3NXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 09:23:16 -0400
Date: Sun, 30 Mar 2008 09:13:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: "Try to stop Tx aggregation on non active TID" messages
Message-ID: <20080330131347.GB3748@tuxdriver.com> (sfid-20080330_142318_287156_5CCD8032)
References: <1206568750.22530.8.camel@johannes.berg> <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com> <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 30, 2008 at 02:56:27PM +0300, Ron Rindjunsky wrote:
> > > we have a slew of messages saying
> > >
> > > [18131.640793] Stop a BA session requested for 00:1a:2a:2c:a2:c5 tid 13
> > > [18131.640798] Try to stop Tx aggregation on non active TID

> ok, i checked it. i think it is the same as the Rx issue we had. those
> prints can be eliminated by .config file's MAC80211_HT_DEBUG. if we
> don't use this flag what's the use of it? if we do use it, i would
> like to insert the Rx prints back as well.

Perhaps use MAC80211_VERBOSE_DEBUG?

-- 
John W. Linville
linville@tuxdriver.com
