Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50162 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZFWETh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 00:19:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 21:19:41 -0700
Date: Tue, 23 Jun 2009 09:49:34 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Joseph Cheek <joseph@cheek.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"parag.warudkar@gmail.com" <parag.warudkar@gmail.com>,
	Gaurav Jauhar <Gaurav.Jauhar@Atheros.com>,
	"rootkit85@yahoo.it" <rootkit85@yahoo.it>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
Message-ID: <20090623041934.GA5040@senthil-lnx.users.atheros.com>
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com> <4A3FD26C.4070503@cheek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A3FD26C.4070503@cheek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joseph,

Not sure what exactly you are tring. However, if you happen to notice the XMIT
being stuck, then please try the patch titled "Fix TX hang issue with Atheros chipsets"
and "schedule aggregation regardless of queue depth" (sent to wireless-testing
mailing list and yet to be merged into tip)

Thanks
Senthil

On Tue, Jun 23, 2009 at 12:20:20AM +0530, Joseph Cheek wrote:
> I will attempt to repro my xmit hangs bugs on today's wireless testing.
> I haven't submitted a kernel.org bug on it, just mentioned it on the
> ath9k list several times.  I can submit a kernel.org bug for it tho,
> assuming it repros (I've had it ever since Christmas, but who knows?).
> 
> Joseph Cheek
> 
> Luis R. Rodriguez wrote:
> > We're down to 2 kernel.org bug reports for ath9k:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=13581
> > "ath9k doesn't work with newer kernels"
> > This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=13141
> > "AR5008/DWA-552 - Very slow"
> > Patches have been supplied, needs user feedback.
> >
> > If you are aware of any other issues please do report.
> >
> >   Luis
> > _______________________________________________
> > ath9k-devel mailing list
> > ath9k-devel@lists.ath9k.org
> > https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> >
> >
