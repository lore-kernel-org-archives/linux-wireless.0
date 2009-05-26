Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37803 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZEZIA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 04:00:29 -0400
Date: Tue, 26 May 2009 09:55:04 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Galen P Zink <galen@zinkconsulting.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Experimental Changes for Latency & Reliability
Message-ID: <20090526075503.GA3321@tuxdriver.com>
References: <19A53295-8338-45FA-BBEA-C0D48766DBED@zinkconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19A53295-8338-45FA-BBEA-C0D48766DBED@zinkconsulting.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 04:15:02PM -0700, Galen P Zink wrote:
> I'm experimenting with an application where adjusting the retransmit and 
> rate control policies could optimize performance. For my application, 
> latency, reliability and throughput are all concerns, with latency being 
> the largest concern, followed by reliability and throughput.

This seems like the kind of proposal that needs more data to support
it.  What testing and measurement has been done with your changes?
If possible, show numbers gathered both with the changes individually
and with them together (possibly in various combinations).

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
