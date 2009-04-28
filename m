Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57645 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760964AbZD1QqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 12:46:05 -0400
Date: Tue, 28 Apr 2009 11:52:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mcgrof@gmail.com, nbd@openwrt.org
Subject: Re: [PATCH 1/7] ath5k: Allow user/driver to set txpower
Message-ID: <20090428155244.GD4113@tuxdriver.com> (sfid-20090428_184616_581281_42E80DCA)
References: <20090416002220.GA4138@makis> <20090424040143.GB3277@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090424040143.GB3277@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 24, 2009 at 12:01:43AM -0400, Bob Copeland wrote:
> On Thu, Apr 16, 2009 at 03:22:20AM +0300, Nick Kossifidis wrote:
> >  * Now that we have regulatory control enable the driver to set txpower on hw
> >  * Also use txpower table offset so that we can match power range set by user/driver with indices on power table.
> 
> BTW I gave this patchset a spin on my rf 5413 and it works fine here, 
> so feel free to add my Acked-By on the series.  Does it need anything
> besides a reposting with 72-col changelogs?

The series seems fine, but I was waiting for a repost with the
narrower changelogs...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
