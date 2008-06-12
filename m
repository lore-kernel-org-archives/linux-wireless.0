Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:32474 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYFLVoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 17:44:16 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2224062rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 14:44:14 -0700 (PDT)
Message-ID: <84144f020806121444i43d381ehdee1774c135d8841@mail.gmail.com> (sfid-20080612_234420_852466_8A92072D)
Date: Fri, 13 Jun 2008 00:44:13 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] ssb: Fix coherent DMA mask for PCI devices
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	"Glauber Costa" <gcosta@redhat.com>
In-Reply-To: <200806121533.14435.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806121533.14435.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 4:33 PM, Michael Buesch <mb@bu3sch.de> wrote:
> This fixes setting the coherent DMA mask for PCI devices.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> John, please queue this bugfix for 2.6.26
>
> The whole SSB DMA API should be rewritten, as it makes too many bad
> assumptions about the other subsytems. I will do that soon.
> But let's apply this patch for now, as it fixes this particular bug.

Hmm. Does the patch have anything to do with this bug report?

http://bugzilla.kernel.org/show_bug.cgi?id=10819
