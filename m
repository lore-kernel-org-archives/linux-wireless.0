Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZKBTzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 14:55:13 -0500
Subject: Re: [PATCH] libertas: remove internal buffers from GSPI driver
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	sebatian@breakpoint.cc, george.shore@imgtec.com
In-Reply-To: <45e8e6c40910291048g2958c086oa6b7a39dbb68258f@mail.gmail.com>
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com>
	 <1256749998.3850.45.camel@localhost.localdomain>
	 <45e8e6c40910291048g2958c086oa6b7a39dbb68258f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 11:54:35 -0800
Message-Id: <1257191675.1027.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-29 at 10:48 -0700, Andrey Yurovsky wrote:
> On Wed, Oct 28, 2009 at 10:13 AM, Dan Williams <dcbw@redhat.com> wrote:
> > Looks OK to me, but I don't have any of the SPI hardware so when you get
> > a Tested-by:, let me know and I'll ack.
> 
> Thanks Dan, by the way the issue with WPA2 and IEEE PS is unrelated to
> this patch (that is, I can reproduce it without the patch applied) so
> we'll need to address that separately.  So at this point we have:
> 
> Tested-by: George Shore <george.shore@imgtec.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>


