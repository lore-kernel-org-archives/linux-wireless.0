Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4597 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030872AbXCNUCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 16:02:22 -0400
Date: Wed, 14 Mar 2007 15:49:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] Eliminate some 'G Mode Enable' magic numbers
Message-ID: <20070314194950.GG3372@tuxdriver.com>
References: <45f82054.fJi116VPchav9Mns%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45f82054.fJi116VPchav9Mns%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2007 at 11:18:28AM -0500, Larry Finger wrote:
> In code manipulating the TM State Low register of 802.11 cores, two
> different magic numbers are used to reference the 'G Mode Enable' bit.
> One of these, 0x20000000, is clear, but the other, (0x800 << 18), is not.
> This patch replaces both types with a defined constant. In addition, two
> bits in the TM State High registers are given definitions to help in
> following the code.

Looks reasonable to me -- not sure why this is an RFC?  Does anyone
object?

John
-- 
John W. Linville
linville@tuxdriver.com
