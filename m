Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55723 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2HBSPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 14:15:32 -0400
Date: Thu, 2 Aug 2012 14:13:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tim and Alison Bentley <Home@TRARBentley.net>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Bitterli <felixb@qca.qualcomm.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] ath9k: Add PID/VID support for AR1111
Message-ID: <20120802181343.GA18293@tuxdriver.com> (sfid-20120802_201535_729853_410CDBB2)
References: <1343888930-353-1-git-send-email-mohammed@qca.qualcomm.com>
 <CAB=NE6WYGefu8vYrO05tq=5qnCcMqWtUQkTzisR2sfpTLMx8WQ@mail.gmail.com>
 <CAAT9HshKC9+YiP2YzVGO_nuRsyvbgBeUvj2+r2Wzj1wU-QV7-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAT9HshKC9+YiP2YzVGO_nuRsyvbgBeUvj2+r2Wzj1wU-QV7-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2012 at 07:05:12PM +0100, Tim and Alison Bentley wrote:
> On 2 August 2012 18:43, Luis R. Rodriguez <rodrigue@qca.qualcomm.com> wrote:
> 
> > On Wed, Aug 1, 2012 at 11:28 PM, Mohammed Shafi Shajakhan
> > <mohammed@qca.qualcomm.com> wrote:
> > > From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> > >
> > > AR1111 is same as AR9485. The h/w
> > > difference between them is quite insignificant,
> > > Felix suggests only very few baseband features
> > > may not be available in AR1111. The h/w code for
> > > AR9485 is already present, so AR1111 should
> > > work fine with the addition of its PID/VID.
> > >
> > > Cc: stable@vger.kernel.org [2.6.39+]
> > > Cc: Felix Bitterli <felixb@qca.qualcomm.com>
> > > Reported-by: Tim and Alison Bentley <Home@trarbentley.net>
> > > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> >
> > Nice! I'd be happy with this going in once we get a Tested-by: report.
> > Dan, Tim?
> >
> >
> 
> Will test tomorrow when I have time

Hmmm...well, I just pushed it to wireless.git.  I won't push it to
Dave until sometime tomorrow, to give a chance for some test.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
