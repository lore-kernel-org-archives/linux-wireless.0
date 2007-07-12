Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37198 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935125AbXGLQkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 12:40:25 -0400
Message-ID: <46965977.7020807@lwfinger.net>
Date: Thu, 12 Jul 2007 11:40:23 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: Dan Williams <dcbw@redhat.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6] SoftMAC : fix duplicate display of channel in scan
References: <20070710184155.GA6955@bougret.hpl.hp.com> <4693DD18.1010905@lwfinger.net> <1184211018.9446.0.camel@localhost.localdomain> <20070712163440.GA13445@bougret.hpl.hp.com>
In-Reply-To: <20070712163440.GA13445@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Tourrilhes wrote:
> 
> 	Well, I actually like forcing driver to use frequency, because
> that's an absolute physical measure and contains more meaning.

Yes, but it is easier to keep a channel number in your head than a frequency.

Larry
