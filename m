Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3BYQbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:31:10 -0500
Message-ID: <1361809857.9192.0.camel@jlt4.sipsolutions.net> (sfid-20130225_173113_364657_2FD82EAB)
Subject: Re: [PATCH -next] iwlwifi: convert to use simple_open()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Feb 2013 17:30:57 +0100
In-Reply-To: <CAPgLHd9VC5b+AVHcVEPMayewirKzPmmrNczS7y6OL59N2uCj8Q@mail.gmail.com> (sfid-20130225_142418_429739_A39EEC8D)
References: <CAPgLHd9VC5b+AVHcVEPMayewirKzPmmrNczS7y6OL59N2uCj8Q@mail.gmail.com>
	 (sfid-20130225_142418_429739_A39EEC8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 21:24 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This removes an open coded simple_open() function and
> replaces file operations references to the function
> with simple_open() instead.

Applied, thanks.

johannes

