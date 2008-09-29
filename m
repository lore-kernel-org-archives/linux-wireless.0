Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51338 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYI2Xx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 19:53:58 -0400
Subject: Re: Getting country alpha2 on network manager and using it for crda
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@atheros.com
In-Reply-To: <43e72e890809291354u563b6c68i3a137cc129e65f86@mail.gmail.com>
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
	 <1222440218.19895.19.camel@localhost.localdomain>
	 <1222584975.9600.2.camel@californication> <20080929183350.GC6203@tesla>
	 <1222720776.27930.35.camel@localhost.localdomain>
	 <43e72e890809291354u563b6c68i3a137cc129e65f86@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 01:53:57 +0200
Message-Id: <1222732437.1825.31.camel@violet.holtmann.net> (sfid-20080930_015402_940461_130F9108)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> > I hesitate to try and specify an LSB-standard file anywhere for this,
> > not sure we need that.  NM might want to store this value
> > per-connection, or might want to store the value system-wide, or
> > whatever.  I don't really see the value in standardizing the location of
> > alpha2 config.
> 
> The only reason why I was thinking of having a standard place for it
> is that there may be more than one device which can help update the
> country based on data it has (GPS, user, etc) and the fact that if we
> are going to set this somewhere perhaps some other things can make use
> of this as well?

don't go that way. It will cause to many problems. We can add an option
to the wpa_supplicant file if you really wanna store it (for the command
line guys). Leave the rest to NetworkManager.

Regards

Marcel


