Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab1AaVnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:43:46 -0500
Subject: Re: Review of EN 301 893 1.5.1 and 1.6.1 changes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org,
	Kathy Giori <Kathy.Giori@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTi=b-Tm7r1eODgAQqpQJuimD0+dQkHFB4YV06kES@mail.gmail.com>
References: <AANLkTim3CG+aN9QGhGOfBD9+BSYsgQW_ACC0o+k9H-rt@mail.gmail.com>
	 <AANLkTinuFzBMMLd08Zpkf8iGBO-YdM2Ni-KtNCNxuUbT@mail.gmail.com>
	 <AANLkTi=b-Tm7r1eODgAQqpQJuimD0+dQkHFB4YV06kES@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 22:43:45 +0100
Message-ID: <1296510225.3812.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this email is on a public list. If you can't tell that from the Cc
line of the email, I'm not sure you should be working in this field. If
you think I'm mocking you, maybe I am :P

On Mon, 2011-01-31 at 13:33 -0800, Luis R. Rodriguez wrote:
> FYI - European conformance spec for 5 GHz Radio LANs has some slight
> modifications which Johannes has pointed out which we have reviewed
> today in consideration for our new DFS design. The skinny is that our
> implementation of using 3 regions are OK and we will move forward with
> that.

I just fear that will not allow us to keep manoeuvring effectively in
the future, because then we need to change all the implementations,
potentially old ones, rather than just updating the database.

I wasn't so much thinking of the pulse patterns though as the other
timings like the airtime allowed to use before moving onto a new
channel.

johannes

