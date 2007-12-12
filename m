Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:1091 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXLLQwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 11:52:08 -0500
Received: by py-out-1112.google.com with SMTP id u77so773499pyb.16
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2007 08:52:06 -0800 (PST)
Message-ID: <43e72e890712120852u18585536yd2a040d772f873e3@mail.gmail.com> (sfid-20071212_165213_567843_9C05F2CF)
Date: Wed, 12 Dec 2007 11:52:05 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: Misleading PCI id information on chipsets supported by ath5k
Cc: "Joachim Frieben" <jfrieben@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0712112237rc9f7c06g9c1c5f46943e1d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl>
	 <40f31dec0712112237rc9f7c06g9c1c5f46943e1d0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 12, 2007 1:37 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:

> > Strange enough, 001c is cited as an [unsupported] (b/g) device whereas 0013 should be an (a/b/g) device which is apparently wrong. So, either the PCI id is not an appropriate way to label whether a device is supported or not, or the support page is wrong. Needless to say that the DWL-G520 does not work with ath5k. Right now, it does not even scan access points at all. Could some authorized person have a look into this and make the necessary corrections on the web page?

The wiki lets anyone make edits, you just need to register first.

  Luis
