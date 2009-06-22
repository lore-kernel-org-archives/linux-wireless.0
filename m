Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZFVQzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 12:55:46 -0400
Subject: Re: iwl3945 not working after recent commits
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, Darren Blaber <dmbtech@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890906192221p5cc67d28gb14b214bbf252ad@mail.gmail.com>
References: <4A3C2036.6060506@gmail.com>
	 <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
	 <4A3C4593.6050707@gmail.com>
	 <43e72e890906191915g2c9736f2i4633c8ed3766fe3b@mail.gmail.com>
	 <4A3C4745.7000706@gmail.com>
	 <43e72e890906191924m2f83815fp860c0a277e44d2e1@mail.gmail.com>
	 <87ws77o76m.fsf@litku.valot.fi>
	 <43e72e890906192221p5cc67d28gb14b214bbf252ad@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:03:02 -0700
Message-Id: <1245690182.24303.488.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-06-19 at 22:21 -0700, Luis R. Rodriguez wrote:
> On Fri, Jun 19, 2009 at 9:33 PM, Kalle Valo<kalle.valo@iki.fi> wrote:
> > "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
> >
> >>> I'm using 2.6.30 with the KMS radeon patches, don't know if that is
> >>> interfering. I'll try wireless-testing directly.
> >>
> >> Yeah this is odd, 2.6.30 shouldn't have an issue with backport unless
> >> I'm missing something. Let us know how it goes with wireless-testing.
> >
> > I'm using latest wireles-testing and I have iwl3945 on my X60s. iwl3945
> > is working fine for me.
> 
> Yeah the user tried a vanilla 2.6.30 and it seems to be working fine
> now, it seems related to kms somehow.

Darren also submitted a kernel.org (#13585) bug which was closed by
himself with reason "Turns out it was a bad development kernel from
ubuntu.".

Reinette


