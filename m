Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53973 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2DCMLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:11:55 -0400
Message-ID: <1333455114.3574.15.camel@jlt3.sipsolutions.net> (sfid-20120403_141159_401224_41050604)
Subject: Re: 802.11ac support
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Date: Tue, 03 Apr 2012 14:11:54 +0200
In-Reply-To: <1333454805.3574.14.camel@jlt3.sipsolutions.net> (sfid-20120403_140651_648547_5B4897F9)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	 <4F471F40.8060503@posedge.com>
	 <1330070145.3426.8.camel@jlt3.sipsolutions.net>
	 <4F4772AB.9000305@posedge.com>
	 <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com>
	 (sfid-20120225_202329_108179_7C3BAD32) <1330205424.3509.5.camel@jlt3.sipsolutions.net>
	 <eab3dfdc8ebc87ec08ca64db9f237d90@posedge.com>
	 (sfid-20120402_104501_564453_6BF9F70F) <1333454805.3574.14.camel@jlt3.sipsolutions.net>
	 (sfid-20120403_140651_648547_5B4897F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 14:06 +0200, Johannes Berg wrote:

> In any case, here's my list of things I think will/may need to be done
> for 11ac in the stack:
[...]

It'd also be nice to have iw parse the VHT IEs properly, completely
forgot about that (but it's really easy)

johannes

