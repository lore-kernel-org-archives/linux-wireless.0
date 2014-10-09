Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58684 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaJIPj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 11:39:57 -0400
Message-ID: <1412869190.1828.58.camel@jlt4.sipsolutions.net> (sfid-20141009_174000_260865_6FC23144)
Subject: Re: [PATCH v2] Add mpp get/dump commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 09 Oct 2014 17:39:50 +0200
In-Reply-To: <CAGnRvuoERgLuhJf4+2+PwOctVg-dzD4kPLiAsOYOuCzf+2FF4g@mail.gmail.com> (sfid-20141009_173602_692753_BE0EEE0F)
References: <1410505183-7325-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1412865379.1828.52.camel@jlt4.sipsolutions.net>
	 <CAGnRvuoERgLuhJf4+2+PwOctVg-dzD4kPLiAsOYOuCzf+2FF4g@mail.gmail.com>
	 (sfid-20141009_173602_692753_BE0EEE0F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 17:35 +0200, Henning Rogge wrote:

> Had to change it to make the source compile... so next time change it,
> but not add it to the commit?

Yeah, see over on the thread with Lorenzo as well, where I explained
this. I just copy nl80211.h from the kernel tree to make sure no
mismatches happen.

johannes

