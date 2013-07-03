Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:61311 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3GCUS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 16:18:27 -0400
Received: by mail-la0-f51.google.com with SMTP id fq12so547150lab.10
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 13:18:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wqp8uijf.fsf@nemi.mork.no>
References: <CAB=NE6V_PKG2UBSLPRhziUDcFzFi8uOJNiNzoPNaK0oU7rmZuQ@mail.gmail.com>
 <87wqp8uijf.fsf@nemi.mork.no>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 3 Jul 2013 13:18:05 -0700
Message-ID: <CAB=NE6VLuMEZLhUFep3GxvSyZpaebBNBdEOFBphhAF2tm_E2SA@mail.gmail.com> (sfid-20130703_221832_546882_58E82343)
Subject: Re: [wireless-regdb] Updates to wireless-regdb review - vendor
 namespaces and VHT80
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 1:58 AM, Bjørn Mork <bjorn@mork.no> wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
>
>> In the meantime, while that gets developed, I'd still like to supply
>> patches to enable VHT80 for a few countries without hopefully such
>> high bar for documentation as I cannot get this information.
>
> I believe VHT80 (and VHT160) is allowed by current regulations in a
> large number of countries, and that the current db entries are in fact
> wrong by stating any upper channel width limits at all in the 5 GHz
> bands.
>
> For example, regulations in most CEPT countries are likely based on
>
>  "ECC/DEC/(04)08 on the harmonised use of the 5 GHz frequency bands for
>   the implementation of Wireless Access Systems including Radio Local
>   Area Networks (WAS/RLANs)"
>
> or a previous version of that decision.  Which is available here:
> http://www.erodocdb.dk/Docs/doc98/official/pdf/ECCDEC0408.PDF
>
> Quoting:
>
>  "considering
>   ..
>
>   e. that the systems covered by this ECC Decision operate typically in a 20 MHz channel bandwidth, other
>     values for the channel bandwidth are also feasible provided they comply with the relevant maximum mean
>     e.i.r.p. and the corresponding maximum mean e.i.r.p. density limits;
>  "
>
> and the continues deciding the mentioned power and power density limits
> only, without any specific channelization.  This document clearly allows
> and anticipates both wider and narrower channels, and so does most
> likely the national regualations implementing the decision.
>
> The list of CEPT countries implementating this decision is here:
> http://www.erodocdb.dk/doks/implement_doc_adm.aspx?docid=2033

Thanks, this seems to be in agreement with the countries I was
considering update that fall under that group that I had updates for
except for one country alone: Russia.

I'll use the information you provided to update the CEPT ones though.

  Luis
