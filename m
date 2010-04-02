Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32974 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0DBBxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 21:53:44 -0400
Subject: Re: firmware_loading_store: vmap() failed, broken firmware with
 kernles .27 - .30
From: Pavel Roskin <proski@gnu.org>
To: Golden <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <365137.1684.qm@web56804.mail.re3.yahoo.com>
References: <365137.1684.qm@web56804.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 21:53:43 -0400
Message-Id: <1270173223.9735.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-31 at 14:56 -0700, Golden wrote:

> This appears to be an important bug fix for a variety of users with
> older kernels. Can you prepare proper patch for this and did you have
> a chance to test if these amendments cause trouble with newer
> kernels? 

I realize that it's an important issue, but I don't have time to look
for a solution right now.  I did my part by confirming the problem on an
2.6.28.10 kernel.  I don't see it on other kernels, but since it's a
race condition, I cannot say definitely that the same condition cannot
happen on another system running a newer kernel.

-- 
Regards,
Pavel Roskin
