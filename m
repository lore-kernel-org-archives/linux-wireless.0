Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35036 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKUUAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 15:00:09 -0500
Date: Fri, 21 Nov 2014 14:53:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-11-21
Message-ID: <20141121195318.GB24984@tuxdriver.com> (sfid-20141121_210029_603237_ED5BD346)
References: <20141121183014.GA24984@tuxdriver.com>
 <546F8D2F.2070003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <546F8D2F.2070003@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2014 at 01:06:23PM -0600, Larry Finger wrote:
> On 11/21/2014 12:30 PM, John W. Linville wrote:
> >Dave,
> >
> >Please pull this batch of updates intended for the 3.19 stream...
> >
> 
> ---snip---
> 
> >Larry Finger (3):
> >       rtlwifi: Fix setting of tx descriptor for new trx flow
> >       rtlwifi: Fix errors in descriptor manipulation
> >       rtlwifi: rtl8192se: Fix connection problems
> 
> I probably do not understand the update process, but the above 3 patches
> need to be in kernel 3.18, not 3.19.

They are -- I pulled the wireless tree in order to avoid some merge
problems...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
