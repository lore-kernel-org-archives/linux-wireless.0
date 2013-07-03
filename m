Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52734 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab3GCI7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 04:59:01 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb\@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [wireless-regdb] Updates to wireless-regdb review - vendor namespaces and VHT80
References: <CAB=NE6V_PKG2UBSLPRhziUDcFzFi8uOJNiNzoPNaK0oU7rmZuQ@mail.gmail.com>
Date: Wed, 03 Jul 2013 10:58:12 +0200
In-Reply-To: <CAB=NE6V_PKG2UBSLPRhziUDcFzFi8uOJNiNzoPNaK0oU7rmZuQ@mail.gmail.com>
	(Luis R. Rodriguez's message of "Tue, 2 Jul 2013 17:38:32 -0700")
Message-ID: <87wqp8uijf.fsf@nemi.mork.no> (sfid-20130703_105906_622772_2843C600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> In the meantime, while that gets developed, I'd still like to supply
> patches to enable VHT80 for a few countries without hopefully such
> high bar for documentation as I cannot get this information.

I believe VHT80 (and VHT160) is allowed by current regulations in a
large number of countries, and that the current db entries are in fact
wrong by stating any upper channel width limits at all in the 5 GHz
bands.

For example, regulations in most CEPT countries are likely based on

 "ECC/DEC/(04)08 on the harmonised use of the 5 GHz frequency bands for
  the implementation of Wireless Access Systems including Radio Local
  Area Networks (WAS/RLANs)"

or a previous version of that decision.  Which is available here:
http://www.erodocdb.dk/Docs/doc98/official/pdf/ECCDEC0408.PDF

Quoting:

 "considering
  ..

  e. that the systems covered by this ECC Decision operate typically in a 20 MHz channel bandwidth, other
    values for the channel bandwidth are also feasible provided they comply with the relevant maximum mean
    e.i.r.p. and the corresponding maximum mean e.i.r.p. density limits;
 "

and the continues deciding the mentioned power and power density limits
only, without any specific channelization.  This document clearly allows
and anticipates both wider and narrower channels, and so does most
likely the national regualations implementing the decision.

The list of CEPT countries implementating this decision is here:
http://www.erodocdb.dk/doks/implement_doc_adm.aspx?docid=2033



Bjørn
