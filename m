Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38310 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbKZRk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:40:28 -0500
Message-ID: <1448559624.2167.37.camel@sipsolutions.net> (sfid-20151126_184031_090732_F4744051)
Subject: Re: [PATCH] Fix memory leak if nla_put fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Rahul Jain <rahul.jain@samsung.com>
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>
Date: Thu, 26 Nov 2015 18:40:24 +0100
In-Reply-To: <1448365527-14498-1-git-send-email-rahul.jain@samsung.com>
References: <1448365527-14498-1-git-send-email-rahul.jain@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-11-24 at 17:15 +0530, Rahul Jain wrote:
> From: Amit Khatri <amit.khatri@samsung.com>
> 
> Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
> Signed-off-by: Rahul Jain  <rahul.jain@samsung.com>
> 
> avoid memory leak because of nla_put_failure
> 
Please fix coding style, and put the message before signed-off-by :)

johannes
