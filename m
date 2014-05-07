Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47306 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaEGUpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:45:11 -0400
Date: Wed, 7 May 2014 16:38:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k mailing list <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
Message-ID: <20140507203828.GG20432@tuxdriver.com> (sfid-20140507_224517_590686_E42491E8)
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
 <20140507195435.GF20432@tuxdriver.com>
 <CAB=NE6XLnK-YKigXs8-R-H72rDJ6oDyChQhRLFcqzchFgO+BZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6XLnK-YKigXs8-R-H72rDJ6oDyChQhRLFcqzchFgO+BZA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2014 at 01:03:00PM -0700, Luis R. Rodriguez wrote:
> On Wed, May 7, 2014 at 12:54 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Is there any hope for getting a more complete fix from the ath9k guys
> > in short order?
> 
> Wait, who are the ath9k folks now exactly ?

A better question may be, who are the qualcomm folks now exactly? ;-)

Anyway, I hope that the ath9k guys know who they are and will respond.
If there aren't any, then I guess we'll have to start slapping bubble
gum and popsicle sticks onto ath9k...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
