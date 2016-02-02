Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36155 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbcBBQTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 11:19:15 -0500
Date: Tue, 2 Feb 2016 21:48:59 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Mcquade <paulmcquad@gmail.com>
Cc: kvalo@codeaurora.org, zajec5@gmail.com, johannes.berg@intel.com,
	davem@davemloft.net, joe@perches.com, m@bues.ch,
	mike.looijmans@topic.nl, cengelma@gmx.at, khoroshilov@ispras.ru,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [1/3] net: wireless: rsi: Coding Spaces
Message-ID: <20160202161859.GB8235@sudip-laptop> (sfid-20160202_171935_782507_752E8F4A)
References: <1445122898-5810-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445122898-5810-1-git-send-email-paulmcquad@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2015 at 12:01:36AM +0100, Paul Mcquade wrote:
> Removed space before that ','
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>

The From: name and Signed-off-by: name should be same else some of the
stats generating tools will break. It should be Paul McQuade, not
Paul Mcquade. Maybe you have modified your .gitconfig recently.

And in the subject net: wireless: is not required.
Can you please send v2..

regards
sudip
