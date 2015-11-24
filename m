Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34295 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbbKXHcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 02:32:18 -0500
Date: Tue, 24 Nov 2015 13:02:05 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	libertas-dev@lists.infradead.org,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] libertas: fix possible NULL dereference
Message-ID: <20151124073205.GA18880@sudip-pc> (sfid-20151124_083239_205311_6F2C5146)
References: <1448281922-20382-1-git-send-email-sudipm.mukherjee@gmail.com>
 <CAHp75Veb4UBKrGsODoKnZrvOZUTEm78yBvhmBRn68oZYRecdQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHp75Veb4UBKrGsODoKnZrvOZUTEm78yBvhmBRn68oZYRecdQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 24, 2015 at 01:43:38AM +0200, Andy Shevchenko wrote:
> On Mon, Nov 23, 2015 at 2:32 PM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> > We were dereferencing cmd first and checking for NULL later. Lets first
> > check for NULL.
> 
> However the patch is valid due to reducing error prone part, the
> commit message seems wrong.

I will send v2 with modified commit message.

regards
sudip
