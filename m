Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:44581 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554AbcF0BNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 21:13:53 -0400
Message-ID: <1466990029.1847.74.camel@perches.com> (sfid-20160627_031459_954813_56900DBF)
Subject: Re: [PATCH] rtlwifi: Add missing newlines to RT_TRACE calls
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 26 Jun 2016 18:13:49 -0700
In-Reply-To: <577070D9.5080503@lwfinger.net>
References: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
	 <577070D9.5080503@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-06-26 at 19:18 -0500, Larry Finger wrote:
> On 06/26/2016 02:34 PM, Joe Perches wrote:
> > 
> > RT_TRACE does not add a newline to the end of a message and always
> > emits at KERN_DEBUG so these are susceptible to message interleaving
> > from other processes without the newline.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> This patch does not apply to the wireless-drivers-next repo. Which one
> did you use?

linux-next

