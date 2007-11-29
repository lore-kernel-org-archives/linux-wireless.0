Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbXK2Tkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 14:40:43 -0500
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
From: Dan Williams <dcbw@redhat.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <20071129090505.7d0905ad@morte>
References: <20071117023548.79a7a33c@morte>
	 <1195493707.3248.14.camel@localhost.localdomain>
	 <20071119190749.7a9e857c@morte>
	 <1195502746.6479.11.camel@localhost.localdomain>
	 <20071129090505.7d0905ad@morte>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 14:35:51 -0500
Message-Id: <1196364951.11556.29.camel@localhost.localdomain> (sfid-20071129_194047_373892_0C9D1AEF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-29 at 09:05 +0100, Stefano Brivio wrote:
> On Mon, 19 Nov 2007 15:05:46 -0500
> Dan Williams <dcbw@redhat.com> wrote:
> 
> > Which branch of wireless-2.6 are you running?  What kernel version?
> 
> Any news? Should I provide any additional debugging information? Thank you.

I tried this last week with the wireless-2.6/everything libertas bits on
2.6.22 and it worked fine there, with the latest firmware from
laptop.org.  Is your bcdDevice 3006 you said?  You may need to flash the
Boot2 firmware.

Dan


