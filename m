Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:8850 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753367Ab1JUKVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 06:21:53 -0400
Date: Fri, 21 Oct 2011 12:22:22 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111021102221.GA1463@ecki.lan> (sfid-20111021_122156_867019_00905B2F)
References: <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
 <20111004181534.GA1502@ecki>
 <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
 <20111005062528.GA1403@ecki>
 <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
 <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
 <20111015093902.GA23520@ecki>
 <CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
 <20111018064459.GA1442@ecki>
 <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 18, 2011 at 03:05:38PM +0800, Adrian Chadd wrote:
>
> Hm, which version of the AR9285 is it, exactly?
> Would you just do a quick check (or code hack) and see if it matches
> the AR_SREV_9285SE_20 (or similar) macro?

It matches AR_SREV_9285, but it does not match AR_SREV_9285E_20.

Clemens
