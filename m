Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f190.google.com ([209.85.223.190]:54044 "EHLO
	mail-iw0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbZIVRB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 13:01:56 -0400
Received: by iwn28 with SMTP id 28so568472iwn.22
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 10:01:59 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Sep 2009 10:01:39 -0700
Message-ID: <43e72e890909221001m19f076d8n64fb012b486f666a@mail.gmail.com>
Subject: Synching trees for BT 3.0 and a possible compat-bluetooth
To: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jothikumar Mothilal <jothikumar.mothilal@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to poke about BT 3.0 synching at the summit. To work on
bluetooth 3.0 we'll need some synching of trees between
wireless-testing and Marcel's bluetooth tree. Also a compat-bluetooth
might be in order to accomplish the same as we do with
compat-wireless, only it would seem logical to consider tying to just
merge this with compat-wireless to get the features required for
bluetooth 3.0; to do this having one tree with both would be nice with
the added benefit of all the same compat-2.6.3x.[ch] files being
reused. Synching of the trees would be required only when a feature on
one tree is not yet available on the latest rc kernel (provided marcel
rebases on Linus' latest rc as well, not sure), this will probably be
important during initial implementation, not sure how much divergence
we should expect after this goes through a release through Linus.

So any thoughts on synching bluetooth and wireless-testing other than
doing so on a private tree for development purposes?

  Luis
