Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60481 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZIWX1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 19:27:20 -0400
Subject: Re: Synching trees for BT 3.0 and a possible compat-bluetooth
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jothikumar Mothilal <jothikumar.mothilal@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kevin Hayes <kevin@atheros.com>
In-Reply-To: <43e72e890909221001m19f076d8n64fb012b486f666a@mail.gmail.com>
References: <43e72e890909221001m19f076d8n64fb012b486f666a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 16:27:06 -0700
Message-Id: <1253748426.2931.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> I forgot to poke about BT 3.0 synching at the summit. To work on
> bluetooth 3.0 we'll need some synching of trees between
> wireless-testing and Marcel's bluetooth tree. Also a compat-bluetooth
> might be in order to accomplish the same as we do with
> compat-wireless, only it would seem logical to consider tying to just
> merge this with compat-wireless to get the features required for
> bluetooth 3.0; to do this having one tree with both would be nice with
> the added benefit of all the same compat-2.6.3x.[ch] files being
> reused. Synching of the trees would be required only when a feature on
> one tree is not yet available on the latest rc kernel (provided marcel
> rebases on Linus' latest rc as well, not sure), this will probably be
> important during initial implementation, not sure how much divergence
> we should expect after this goes through a release through Linus.
> 
> So any thoughts on synching bluetooth and wireless-testing other than
> doing so on a private tree for development purposes?

we don't need this right now. For the initial development of the WiFi
AMP, we will use the fact that you can create HCI RAW devices from a
driver. These are skipped by BlueZ and only show up in hciconfig. That
should be enough for testing.

Regards

Marcel


