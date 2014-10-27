Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45752 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaJ0RaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 13:30:14 -0400
Date: Mon, 27 Oct 2014 13:26:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60GHz band
Message-ID: <20141027172636.GA28300@tuxdriver.com> (sfid-20141027_183024_309453_12E2D2C9)
References: <543D170A.6060709@gmail.com>
 <1465375.2aSLY3brRR@lx-wigig-72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465375.2aSLY3brRR@lx-wigig-72>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2014 at 09:49:52AM +0300, Vladimir Kondratiev wrote:
> On Tuesday, October 14, 2014 02:28:58 PM Xose Vazquez Perez wrote:
> > "(57240 - 65880 @ 2160), (40), NO-OUTDOOR" should(must) be replaced by:
> > "(57000 - 66000 @ 2160), (40)"
> > 
> 
> Yes, looks like you are right. I used draft that I don't see on its location any more,
> and final document indeed says what you wrote.

Would someone like to post a patch to that effect?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
