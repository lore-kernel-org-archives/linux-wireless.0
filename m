Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:43531 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZJ2Rsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 13:48:31 -0400
Received: by pxi9 with SMTP id 9so1327350pxi.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 10:48:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256749998.3850.45.camel@localhost.localdomain>
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com>
	 <1256749998.3850.45.camel@localhost.localdomain>
Date: Thu, 29 Oct 2009 10:48:35 -0700
Message-ID: <45e8e6c40910291048g2958c086oa6b7a39dbb68258f@mail.gmail.com>
Subject: Re: [PATCH] libertas: remove internal buffers from GSPI driver
From: Andrey Yurovsky <andrey@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	sebatian@breakpoint.cc, george.shore@imgtec.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 10:13 AM, Dan Williams <dcbw@redhat.com> wrote:
> Looks OK to me, but I don't have any of the SPI hardware so when you get
> a Tested-by:, let me know and I'll ack.

Thanks Dan, by the way the issue with WPA2 and IEEE PS is unrelated to
this patch (that is, I can reproduce it without the patch applied) so
we'll need to address that separately.  So at this point we have:

Tested-by: George Shore <george.shore@imgtec.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
