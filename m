Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54018 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZGATpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:45:49 -0400
Date: Wed, 1 Jul 2009 15:36:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Subject: Insist on cfg80211 for new drivers?
Message-ID: <20090701193657.GD3473@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost> <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com> <1246396179.4949.76.camel@localhost> <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com> <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com> <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com> <1246473300.30522.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1246473300.30522.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2009 at 02:35:00PM -0400, Dan Williams wrote:

> That's really all I
> care about, I don't want another WEXT-based driver accepted; I want all
> the new ones using cfg80211.

Now there is a discussion we should have had in Berlin...is it time
to insist on cfg80211-based configuration for all new drivers?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
