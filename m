Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:26155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZKATGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 14:06:07 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Sun, 1 Nov 2009 20:04:59 +0100
Cc: Jarek Poplawski <jarkao2@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1256886023.3555.5.camel@johannes.local> <20091030110616.GB6150@ff.dom.local> <20091030150223.GA2586@tuxdriver.com>
In-Reply-To: <20091030150223.GA2586@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200911012004.59718.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 October 2009 16:02:24 John W. Linville wrote:

> Ever since Bartlomiej decided to tear himself away from
> drivers/staging, he has been nothing but negative -- petty, whining,

I think that you should ping Greg about this since somebody impersonating
for me is sending him patches.  Last week alone over 20 such patches were
merged -- who knows what this person might be planning.. ;)

Probably the following patch was the source of confusion:

	http://patchwork.kernel.org/patch/55076/

It just aligns my personal interests w/ ongoing work done by other people,
hch is working on mac80211 via driver and Greg has announced some time ago
that he was going to work on proper rtl819x support.

-- 
Bartlomiej Zolnierkiewicz
