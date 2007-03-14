Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54411 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030658AbXCNUEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 16:04:30 -0400
Message-ID: <45F85546.1010902@lwfinger.net>
Date: Wed, 14 Mar 2007 15:04:22 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] Eliminate some 'G Mode Enable' magic numbers
References: <45f82054.fJi116VPchav9Mns%Larry.Finger@lwfinger.net> <20070314194950.GG3372@tuxdriver.com>
In-Reply-To: <20070314194950.GG3372@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Mar 14, 2007 at 11:18:28AM -0500, Larry Finger wrote:
>> In code manipulating the TM State Low register of 802.11 cores, two
>> different magic numbers are used to reference the 'G Mode Enable' bit.
>> One of these, 0x20000000, is clear, but the other, (0x800 << 18), is not.
>> This patch replaces both types with a defined constant. In addition, two
>> bits in the TM State High registers are given definitions to help in
>> following the code.
> 
> Looks reasonable to me -- not sure why this is an RFC?  Does anyone
> object?

Not so far. I'll make it a proper patch.

Larry
