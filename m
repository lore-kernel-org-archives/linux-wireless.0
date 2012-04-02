Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47851 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2DBNUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 09:20:03 -0400
Received: by dake40 with SMTP id e40so2438845dak.11
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 06:20:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120402123542.GA4567@redhat.com>
References: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
	<CAGXE3d8C61rnWPgRU565n_FjjKTqk4pi9ncmdjxyAmEvVM-uvA@mail.gmail.com>
	<20120402123542.GA4567@redhat.com>
Date: Mon, 2 Apr 2012 15:20:02 +0200
Message-ID: <CAGXE3d_7ONx0=scmicYkvgjYM7ROYuHHNfNbO4xMJfmwM+rbrA@mail.gmail.com> (sfid-20120402_152013_358314_AE962168)
Subject: Re: [PATCH 1/2] rt2x00: configure different txdesc parameters for non
 HT channel
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 2, 2012 at 2:35 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Apr 02, 2012 at 02:09:14PM +0200, Helmut Schaa wrote:
>> Why should we use PIFS for the beacon? Is that what the ralink drivers
>> are doing?
> Hmm, seems that is my own invention. I thought that should be used for
> beacons, but currently I can only find in docs, that this is only needed
> for entering PCF.

Ok, so if we're running in non-HT mode we could just always stick to
TXOP_BACKOFF and only use SIFS for bursts? Makes sense I guess.

Thanks,
Helmut
