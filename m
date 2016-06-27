Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:53623 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571AbcF0B0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 21:26:23 -0400
Message-ID: <1466990779.1847.78.camel@perches.com> (sfid-20160627_032658_344695_CAF66F3C)
Subject: Re: [PATCH] rtlwifi: Add missing newlines to RT_TRACE calls
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 26 Jun 2016 18:26:19 -0700
In-Reply-To: <1466990029.1847.74.camel@perches.com>
References: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
	 <577070D9.5080503@lwfinger.net> <1466990029.1847.74.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-06-26 at 18:13 -0700, Joe Perches wrote:
> On Sun, 2016-06-26 at 19:18 -0500, Larry Finger wrote:
> > 
> > On 06/26/2016 02:34 PM, Joe Perches wrote:
> > > 
> > > 
> > > RT_TRACE does not add a newline to the end of a message and always
> > > emits at KERN_DEBUG so these are susceptible to message
> > > interleaving
> > > from other processes without the newline.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > This patch does not apply to the wireless-drivers-next repo. Which
> > one
> > did you use?
> linux-next

btw: both patches seem to apply to wireless-drivers-next just fine.

$ git rev-parse HEAD
1bb57c8a5e33bcbec031ce0c629968922d5af89d
$ git am ../next/0001-rtlwifi-Create-_rtl_dbg_trace-function-to-reduce-RT_.patch
Applying: rtlwifi: Create _rtl_dbg_trace function to reduce RT_TRACE code size
$ git am ../next/0001-rtlwifi-Add-missing-newlines-to-RT_TRACE-calls.patch
Applying: rtlwifi: Add missing newlines to RT_TRACE calls
