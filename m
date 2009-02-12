Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:65148 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZBLUjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 15:39:55 -0500
Received: by bwz5 with SMTP id 5so1288227bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 12:39:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890902120753w44cab825i861d5c92c4816c61@mail.gmail.com>
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
	 <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
	 <17a838c40902120456wb862200y8717a0d6a061b057@mail.gmail.com>
	 <43e72e890902120753w44cab825i861d5c92c4816c61@mail.gmail.com>
Date: Thu, 12 Feb 2009 21:39:51 +0100
Message-ID: <17a838c40902121239v48bb2657jb540e52520b59a56@mail.gmail.com> (sfid-20090212_214000_352445_474908D7)
Subject: Re: [ath9k-devel] Radar Detection and DFS status
From: Alberto Pollastro <a.pollastro@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 4:53 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Yes, we have indoor and outdoor channel flags. You can supply a patch
> or provide a reference to the regulatory information you are reading
> to determine this and we can patch it up.

I've read the European Directive 2007/90/EC:

http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2007:041:0010:01:EN:HTML

I think that the EC directive has been acknowledged by the Italian
legislation as reported in the following table at page 28 (it's in
Italian, sorry):

http://www.comunicazioni.it/binary/min_comunicazioni/piano_nazionale_ripartizione_frequenze/03%20tabella_B.pdf

I hope I'm not wrong.

Thanks,
Albert.
