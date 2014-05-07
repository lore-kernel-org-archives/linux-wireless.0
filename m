Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaEGM50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:57:26 -0400
Message-ID: <1399467431.10517.36.camel@jlt4.sipsolutions.net> (sfid-20140507_145729_114330_1466913E)
Subject: Re: How to configure monitor devices for HT80?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 07 May 2014 14:57:11 +0200
In-Reply-To: <536A29E0.4030208@candelatech.com>
References: <5367E13C.2020208@candelatech.com>
		  (sfid-20140505_211155_884363_141E505C) <1399317771.22235.23.camel@jlt4.sipsolutions.net>
		 <53692240.5010001@candelatech.com>
	 <1399453264.10517.6.camel@jlt4.sipsolutions.net>
	 <536A29E0.4030208@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 05:41 -0700, Ben Greear wrote:

> Another question:  if I create a monitor interface first, and
> successfully set it's frequency, what do I need to do to allow
> a station to move to a different frequency later?

Nothing - the monitor frequency is always just a hint that you want, if
you start doing other things it gets lost automatically.

johannes

