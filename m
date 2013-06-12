Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3FLLzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 07:55:42 -0400
Message-ID: <1371038139.8601.15.camel@jlt4.sipsolutions.net> (sfid-20130612_135546_273351_BB1BA039)
Subject: Re: [QUERY] Intel Centrino Wireless-N 100 modules vs built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Warne <nick@linicks.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 13:55:39 +0200
In-Reply-To: <1371037816.8601.13.camel@jlt4.sipsolutions.net> (sfid-20130612_135029_092653_B4030FFF)
References: <20130612112326.GA10313@sauron>
	 (sfid-20130612_133412_709863_242F03A2) <1371037816.8601.13.camel@jlt4.sipsolutions.net>
	 (sfid-20130612_135029_092653_B4030FFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Newer versions of udev don't
> respond negatively if they don't have the firmware while running from
> initrd/initramfs, and will leave the driver's request pending to be
> answered once the real filesystem is mounted.

And by "newer", I really mean "anything not ancient", the version with
the logic was 187, released almost a year ago :-)

johannes

