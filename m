Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2GDLbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:31:09 -0400
Message-ID: <1341401467.12432.8.camel@jlt3.sipsolutions.net> (sfid-20120704_133113_677824_0B8D69FC)
Subject: Re: Regression in the latest wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivanich <ivanich@ivanich.org.ua>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Jul 2012 13:31:07 +0200
In-Reply-To: <1957616.7uPhIQSMg3@ivanich> (sfid-20120704_111531_606828_5863F079)
References: <1957616.7uPhIQSMg3@ivanich>
	 (sfid-20120704_111531_606828_5863F079)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 12:15 +0300, Ivanich wrote:
> When trying to stop or restart hostapd it says that it could't be stoped and 
> it isn't possible to kill hostapd process, it running with -Ds status, also it 
> causes problems with all network interfaces, for example ifconfig command 
> froze, and can't even reboot without SysRq.
> Tried clean 3.5.0-rc5-git - it works correctly. I'm using rtl8192ce in AP 
> mode.

Here's a fix I think:

http://p.sipsolutions.net/8a1b875a431e72a0.txt

johannes

