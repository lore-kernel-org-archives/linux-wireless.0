Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47703 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYDDDdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 23:33:25 -0400
Subject: Re: [PATCH] rtl8187b work in progress...
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <200804012340.01354.herton@mandriva.com.br>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
	 <1207074268-16335-1-git-send-email-linville@tuxdriver.com>
	 <200804012109.57965.herton@mandriva.com.br>
	 <200804012340.01354.herton@mandriva.com.br>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 23:33:23 -0400
Message-Id: <1207280003.2585.15.camel@dv> (sfid-20080404_043336_875861_50DB58EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 23:40 -0300, Herton Ronaldo Krzesinski wrote:
> > +		return 0;
>                 ^^^
> Now that I removed this return (obviously wrong heh) It seems to work ok :),
> the rtl8187b I have here at least now successfuly scans for aps/receive data,
> later I'll do more testing/improvements.

Patching the latest linux-wireless with it is not fun, too many
rejects :-(

Considering that compat-wireless brings the goodness of the current
driver to the users of all recent kernels, may I humbly suggest that
linux-wireless is used for development?

-- 
Regards,
Pavel Roskin
