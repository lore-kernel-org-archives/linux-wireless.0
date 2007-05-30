Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34041 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485AbXE3OHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2007 10:07:55 -0400
Message-ID: <465D8538.8070507@garzik.org>
Date: Wed, 30 May 2007 10:07:52 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Please pull 'libertas' branch of wireless-2.6
References: <20070529183347.GD3496@tuxdriver.com>
In-Reply-To: <20070529183347.GD3496@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Lots of stuff here...probably best for 2.6.23...

Is this best for Linux users... or just easy for developers?

Won't putting off all these fixes until 2.6.23 leave the driver released 
in 2.6.22 in shoddy shape?

libertas is upstream now, so we cannot pretend that the driver is 
completely independent from upstream release cycles and maintenance.

libertas fixes should go upstream immediately, since we are in a bugfix 
cycle, and since libertas (from upstream perspective) is about to make 
its big debut on the world stage.

	Jeff



