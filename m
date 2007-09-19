Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51104 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbXISWBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 18:01:43 -0400
Message-ID: <46F19C3C.6090605@garzik.org>
Date: Wed, 19 Sep 2007 18:01:32 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Miller <davem@davemloft.net>, hch@infradead.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net
Subject: Re: Please pull 'p54' branch of wireless-2.6
References: <20070919195527.GD5483@tuxdriver.com> <20070919210405.GA2231@infradead.org> <20070919.141200.56568833.davem@davemloft.net> <20070919212607.GA3036@tuxdriver.com>
In-Reply-To: <20070919212607.GA3036@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Sep 19, 2007 at 02:12:00PM -0700, David Miller wrote:
>> From: Christoph Hellwig <hch@infradead.org>
>> Date: Wed, 19 Sep 2007 22:04:05 +0100
>>
>>> PLease put it into a separate subdirectory, thanks.
>>>
>>> Also net2280.h seems rather oddly named.
>> The next time I rebase I'll try to take care of this for both
>> this driver and the iwlwifi stuff.
> 
> Fine by me, although I swear I remember complaints about adding separate
> directories for drivers...*shrug*...

There were complaints about the nonsensical wireless/mac80211 directory. 
  But if there are enough files, a driver should definitely get its own 
directory.  Like life, it's a balance.  If it's just one or two C files, 
a directory might be overkill.  If it's more, it definitely warrants a 
sub-dir.

	Jeff



