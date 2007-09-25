Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:53860 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbXIYLlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 07:41:11 -0400
To: "Michael Renzmann" <mrenzmann@madwifi.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: Guide on how to submit patches for linux-wireless
References: <43e72e890709241209obc236eav5eca6c0828052ee1@mail.gmail.com>
	<58951.84.58.184.15.1190694911.squirrel@webmail.madwifi.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 25 Sep 2007 13:41:09 +0200
In-Reply-To: <58951.84.58.184.15.1190694911.squirrel@webmail.madwifi.org> (Michael Renzmann's message of "Tue, 25 Sep 2007 06:35:11 +0200 (CEST)")
Message-ID: <m3d4w7m0q2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Michael Renzmann" <mrenzmann@madwifi.org> writes:

> One thing that probably should be added is an explanation of the
> "Changes-licensed-under:" tag that is used in some patches.

I'm not sure it's that easy.

If a patch doesn't create a derivative work (can't be copyrighted)
the licence doesn't matter/exist.

If a patch creates a derivative work then the author can distribute
under a different licence, but the new licence must be written into
the source file being patched anyway.
-- 
Krzysztof Halasa
