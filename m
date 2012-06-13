Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:48305 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752721Ab2FMRMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 13:12:08 -0400
Message-ID: <1339607214.55182.YahooMailClassic@web161701.mail.bf1.yahoo.com> (sfid-20120613_191214_799447_C48B8675)
Date: Wed, 13 Jun 2012 10:06:54 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
To: Dan Williams <dcbw@redhat.com>,
	Andreas Kemnade <andreas@kemnade.info>
Cc: linux-wireless@vger.kernel.org, dsd@laptop.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1339539360.3284.235.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 4 bit is supported.
> The hardware does not impose unresolvable limitations, the
> 2.6.32 kernel
> gives high performance. But since that kernel is not
> mainstream, it is
> very hard to find out which patch gives the slowdown. git
> bisect
> is not very useful in that situation.
> SD memory card reading speed is always ok (on another of the
> integrated
> sd host controllers).

Have you tested receive throughput? Any difference between TX and Rx throughput? 
