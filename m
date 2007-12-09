Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:33547 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751021AbXLIWGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 17:06:22 -0500
Date: Sun, 9 Dec 2007 22:06:21 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209133311.2db5ce4f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <642708.11296.qm@web52902.mail.re2.yahoo.com> (sfid-20071209_220628_186444_745207D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Arjan van de Ven <arjan@infradead.org> wrote:
> can you check if the attr_mem is properly ioremap'd ?
> (probably with ioremap_nocache)

Can you elaborate, please? I am not familiar with these I/O primitives.

> I wonder if there's anything else in that area as well..

So I should check /proc/iomem? But wouldn't Linux complain if two PCI devices conflicted as you're
suggesting?

Cheers,
Chris





      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
