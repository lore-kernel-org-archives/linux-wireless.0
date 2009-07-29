Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:57980 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZG2Jnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:43:50 -0400
Date: Wed, 29 Jul 2009 11:43:48 +0200
Message-Id: <1739409215@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org
Cc: Felix Bitterli <ic.felix@gmail.com>
Subject: Re: ar9170 DWA 160A
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> We have these listed on ar9170 wiki page as under Dlink DWA160A:
> 
> 0x07d1:0x3c10
> 0x0846:0x9010
> 
> A user just reported thy purchased DWA160 by mistake thinking it was
> the same but it turns out it has some other wireless chipset.

hmm, did you check D-Link's product & support side?
http://www.dlink.com/products/?pid=DWA-160

lists two different revisions:
- DWA 160A (usbid 0x07d1:0x3c10)  ar9170 chip
- DWA 160B (usbid 0x07d1:0x3c11)  rt2870 chip


---

> Do any of you have a DWA160A that is claimed by ar9170 or should
> we remove this from the list?

http://www.ubuntu-forum.de/artikel/45079/kompilierungsfehler-compat-wireless-hilfe-beim-beheben.html
"@Fremdkoeperfalle: [...] mein D-Link DWA -160 funktioniert." => ~ "my D-LINK DWA-160 works."
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

