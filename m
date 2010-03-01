Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0CAHtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 02:49:08 -0500
Date: Mon, 1 Mar 2010 08:47:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH resend] airo: return from set_wep_key() when key length
	is zero
Message-ID: <20100301074709.GA2365@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com> <20100208205358.GA3852@tuxdriver.com> <20100226141027.GA10280@dhcp-lab-161.englab.brq.redhat.com> <1267225769.14995.10.camel@localhost.localdomain> <20100227012616.GA2590@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100227012616.GA2590@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2010 at 08:26:17PM -0500, John W. Linville wrote:
> On Fri, Feb 26, 2010 at 03:09:29PM -0800, Dan Williams wrote:
> > On Fri, 2010-02-26 at 15:10 +0100, Stanislaw Gruszka wrote:
> > > Even if keylen == 0 is a bug and should not really happen, better avoid
> > > possibility of passing bad value to firmware.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

This is small v1->v2 patch on top of below commit. You asked for it :)

> commit f09c256375c7cf1e112b8ef6306cdd313490d7c0
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Tue Feb 2 15:34:50 2010 +0100
> 
>     airo: fix setting zero length WEP key

Stanislaw
