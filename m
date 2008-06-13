Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2489 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYFMNcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 09:32:31 -0400
Date: Fri, 13 Jun 2008 09:23:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Maciek Kaliszewski <mkalkal@interia.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
Message-ID: <20080613132317.GB5333@tuxdriver.com> (sfid-20080613_153234_577047_9C69A07D)
References: <4852658A.4040402@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4852658A.4040402@interia.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 02:18:18PM +0200, Maciek Kaliszewski wrote:
> I cannot connect to my WIFI/WPA network using iwl3945 driver.

Any chance that adding a line like this in /etc/modprobe.conf is
helpful?

	options iwl3945 disable_hw_scan=1

Worth a shot... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
