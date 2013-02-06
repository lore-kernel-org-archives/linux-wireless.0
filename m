Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57046 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3BFTa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 14:30:27 -0500
Date: Wed, 6 Feb 2013 14:25:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ognjen Ikovic <ognjen.ikovic@lacitadelleing.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	robertbasic.com@gmail.com
Subject: Re: wireless-regdb: Update regulatory rules for Serbia (RS) on 2.4
 and 5GHz
Message-ID: <20130206192544.GH2148@tuxdriver.com> (sfid-20130206_203031_347537_45E08F9E)
References: <CAL1G+-HfPJnwvisiE5Vr0ihenwKzL3_QL40DLPP_PsPyv+nveQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL1G+-HfPJnwvisiE5Vr0ihenwKzL3_QL40DLPP_PsPyv+nveQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ognjen,

Thank you so much for this timely message!  I apologize for having
overlooked it so far.

I don't suppose that you could translate the information you have
provided into the format used within the regulatory database file?
Also, could you provide a link to the original regulatory document
(even if it is in Serbian)?

Ideally you could post a patch for the db.txt file.  If that is a
problem, simply posting the information should be sufficient.

Thanks!

John

On Thu, Jan 31, 2013 at 03:18:56PM +0100, Ognjen Ikovic wrote:
> Dear Mr. John,
> 
> my name is Ognjen Ikovic and I am R&D engineer from Novi Sad, Serbia. I
> have noticed that You are listed as maintainer for the wireless-regdb
> database, congratulations on a fine work You are doing.
> 
> I have noticed the following inputs in the regulatory database for Serbia
> which are not in line with regulatory documents for Serbia:
> 
> country RS:
>         # 60 gHz band channels 1-4, ref: Etsi En 302 567
>         (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> 
> I was wondering if You could, please, update the regulatory database with
> new information:
> 
> *WAS/RLANs for indoor usage:*
> 1. Frequency Band 2400-2483.5 MHz;  Power 100mW e.i.r.p.; Channel spacing:
> None;
> CEPT document:  ERC/DEC/(01)07, ERC/DEC/(04)07, ERC/REC/70-03; ETSI
> standard EN 300 328
> 
> 2. Frequency Band 5150-5350 MHz;  Power 200mW e.i.r.p.;
> CEPT document:  ERC/DEC/(99)24, ECC/DEC/(04)08, ERC/REC/70-03; ETSI
> standard: EN 300 836, EN 301 893
> 
> *WAS/RLANs for outdoor usage:*
> 1. Frequency Band 2400-2483.5 MHz;  Power 100mW e.i.r.p.; Channel spacing:
> None;
> CEPT document:  ERC/DEC/(01)07, ERC/REC/70-03; ETSI standard EN 300 328
> 
> 2. Frequency Band 5470-5725 MHz;  Power 1W e.i.r.p; Channel spacing: 20
> MHz; TCP required 3dB;  DFS required;
> CEPT document: ECC/DEC/(04)08; ETSI standard: EN 301 893
> 
> I have regulatory document with these information, but it is on Serbian
> language. If You need more information regarding this subject do not
> hesitate to contact me.
> 
> Best regards,
> 
> Ognjen Ikovic
> 
> -- 
> Ognjen Ikovic
> Staff engineer
> ognjen.ikovic@lacitadelleing.com
> +381640272551
> LaCitadelle Inzenjering
> www.lacitadelleing.com

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
