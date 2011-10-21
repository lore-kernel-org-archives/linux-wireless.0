Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:25520 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805Ab1JUTD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 15:03:28 -0400
Date: Fri, 21 Oct 2011 21:03:56 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111021190356.GA26832@ecki.lan> (sfid-20111021_210332_007311_E3DD9D22)
References: <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
 <20111005062528.GA1403@ecki>
 <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
 <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
 <20111015093902.GA23520@ecki>
 <CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
 <20111018064459.GA1442@ecki>
 <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
 <20111021102221.GA1463@ecki.lan>
 <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 21, 2011 at 10:10:21PM +0800, Adrian Chadd wrote:
> 
> If the interrupt storm continue occuring, try putting the whole NIC to
> sleep entirely (ie, call pcipowersave to put the NIC to sleep, then
> make sure the NIC -stays- asleep somehow, ie so nothing else tries
> waking it up.

Is it possible to figure out whether or not it is asleep in the
interrupt routine?
