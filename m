Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2455 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYF1Pq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 11:46:59 -0400
Date: Sat, 28 Jun 2008 11:22:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: George Fong <george@lateralplains.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Problem making compat-wireless-2.6
Message-ID: <20080628152213.GB6110@tuxdriver.com> (sfid-20080628_174702_356571_956897DA)
References: <200806281953.16371.george@lateralplains.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806281953.16371.george@lateralplains.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 07:53:13PM +1000, George Fong wrote:
> Hi guys
> 
> Not sure if this is a bug but I have not been able to make the compat wireless 
> drivers.
> 
> I am running off Fedora 9 (x86_64) with kernel 2.6.25.6-55.fc9.x86_64. I am 
> interested in the iwl4965 driver.

Do you absolutely need the stuff I merged to wireless-next-2.6
yesterday?  If not, I think you will find these kernels from Koji to
otherwise be quite up-to-date:

	http://koji.fedoraproject.org/koji/buildinfo?buildID=54043

Of course, the latest rawhide kernel (still building ATM) has the
latest wireless bits:

	http://koji.fedoraproject.org/koji/buildinfo?buildID=54098

And if you don't want rawhide but still want the latest wireless bits,
there should be a new F9 kernel with those bits "soon" -- watch here:

	http://koji.fedoraproject.org/koji/packageinfo?packageID=8

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
