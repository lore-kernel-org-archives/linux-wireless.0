Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51837 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0CKHkV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 02:40:21 -0500
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
From: Pavel Roskin <proski@gnu.org>
To: Malte Gell <malte.gell@gmx.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201003110748.12919.malte.gell@gmx.de>
References: <201003040835.29387.malte.gell@gmx.de>
	 <1268199428.17677.9.camel@mj>
	 <43e72e891003092352w433c018t3ed05d3279abf67e@mail.gmail.com>
	 <201003110748.12919.malte.gell@gmx.de>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 02:40:19 -0500
Message-Id: <1268293219.2989.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 07:48 +0100, Malte Gell wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote
>  
> > To debug firmware loading you can run
> > udevadm monitor
> > And read all the stuff there when you try to load the driver.
> 
> Thanks for this hint. I tried this now and the attached file ar9170.log 
> contains the output.

Please post your .config file.  I guess you are missing something
obvious, like sysfs support or inotify.

-- 
Regards,
Pavel Roskin
