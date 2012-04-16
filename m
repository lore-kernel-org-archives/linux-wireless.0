Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2DPVmm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:42:42 -0400
Message-ID: <1334612555.5455.0.camel@dcbw.foobar.com> (sfid-20120416_234245_381785_36BE5360)
Subject: Re: [RFC 1/4] libertas: Firmware loading simplifications
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 16:42:35 -0500
In-Reply-To: <CAMLZHHTJ_tX+4D=LRyn6gbNKHeRNW5_j4YS4_qz5MDMROYiCiA@mail.gmail.com>
References: <20120403160104.D765B9D401E@zog.reactivated.net>
	 <1334597520.10194.37.camel@dcbw.foobar.com>
	 <CAMLZHHTJ_tX+4D=LRyn6gbNKHeRNW5_j4YS4_qz5MDMROYiCiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-16 at 14:30 -0600, Daniel Drake wrote:
> On Mon, Apr 16, 2012 at 11:32 AM, Dan Williams <dcbw@redhat.com> wrote:
> > I think the reprogram functionality was intended for the school server
> > use-case.  I was advocating for a standalone firmware flashing tool for
> > this anyway (and had written a Python-based one back in 2007) but if
> > OLPC doesn't support the school server stuff anymore, we can safely
> > remove the flashing capability.
> 
> Yes, unfortunately those efforts are long-dead as it didn't succeed.

Fine by me then, #1 looks good.

Dan

