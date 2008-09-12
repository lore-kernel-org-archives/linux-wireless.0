Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21886 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbYILBDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 21:03:10 -0400
Subject: Re: BMC4310 support (03f0:171d)
From: Pavel Roskin <proski@gnu.org>
To: Nadav Kavalerchik <nadavkav@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com>
	 <4219988b0809011349i640d36e0p497eb8cefe303d0@mail.gmail.com>
	 <200809012333.58897.mb@bu3sch.de>
	 <4219988b0809091240s970c580k763054a56ef740b3@mail.gmail.com>
	 <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 21:03:07 -0400
Message-Id: <1221181387.1351.6.camel@dv> (sfid-20080912_030316_904116_3F429AA7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-09 at 22:41 +0300, Nadav Kavalerchik wrote:
> anything i can do to help ?
> 
>  ndiswrapper can handle the vista drivers ver 6.1 so i am stuck :-(

I guess that you mean that it cannot.

>  throw me a bone :-)

svn co https://ndiswrapper.svn.sourceforge.net/svnroot/ndiswrapper/branches/ndisv6/ndiswrapper

That's an experimental version of ndiswrapper that supports NDIS v6
only.  As far as I know, it's not fully functional, but at least you
don't have to wait for reverse engineering.  NDIS is documented.  I
believe x86_64 has better chances to work than i386.

Just a reminder - please don't discuss issues with ndiswrapper in this
list.  It has a list of its own.

-- 
Regards,
Pavel Roskin
