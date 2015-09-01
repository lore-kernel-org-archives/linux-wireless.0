Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:56170 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751535AbbIAPQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 11:16:05 -0400
Message-ID: <1441120560.3012.30.camel@perches.com> (sfid-20150901_171609_276206_BC7EC81B)
Subject: Re: [PATCH] mwifiex: Make mwifiex_dbg a function, reduce object size
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 01 Sep 2015 08:16:00 -0700
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CB8B595@AcuExch.aculab.com>
References: <1441043205.3276.28.camel@perches.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1CB8B595@AcuExch.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-01 at 15:09 +0000, David Laight wrote:
> From: Joe Perches
> > Sent: 31 August 2015 18:47
> > 
> > The mwifiex_dbg macro has two tests that could be consolidated
> > into a function reducing overall object size ~10KB (~4%).
> > 
> > So convert the macro into a function.
> 
> This looks like it will slow things down somewhat.

I doubt in any meaningful way.


