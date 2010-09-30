Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58968 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0I3NPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 09:15:13 -0400
Date: Thu, 30 Sep 2010 09:00:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] carl9170: updates
Message-ID: <20100930130026.GA2456@tuxdriver.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
 <20100928194041.GA5307@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100928194041.GA5307@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 03:40:41PM -0400, John W. Linville wrote:
> On Mon, Sep 27, 2010 at 01:41:36AM +0200, Christian Lamparter wrote:
> > A few more random changes.
> > Note: I do have some problems with -rc5, so this series
> > might need some external testing.
> > 
> > Christian Lamparter (6):
> >   carl9170: remove non-standard ba session teardown
> >   carl9170: angle brackets for wiki link
> >   carl9170: remove lost-frame workaround
> >   carl9170: fix tx_ampdu_upload counter
> >   carl9170: fix WARN_ON triggered by Broadcom HT STAs
> >   carl9170: revamp carl9170_tx_prepare
> 
> Nothing to address davem's _packed comments?

Please ignore this, I found them. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
