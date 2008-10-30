Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57547 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbYJ3Xme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 19:42:34 -0400
Message-ID: <490A4667.4050100@lwfinger.net> (sfid-20081031_004238_932188_DAFD8F5E)
Date: Thu, 30 Oct 2008 16:42:31 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Piter PUNK <piterpk@terra.com.br>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] rtl8187: Change TX power settings
References: <949582.41137.qm@web23101.mail.ird.yahoo.com>
In-Reply-To: <949582.41137.qm@web23101.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> Hi Larry,
> 
> I think one needs to be more careful about removing some of the
> (priv->hw_rev == RTL8187BvB) in the 2nd half of the patch. The latest vendor driver can stop supporting the older 8187BvB chip (intentionally or by mistake), but linux users often/occasionally have older hardware. I
> think one wants to make sure that numbers from the new code are no-bigger
> than numbers from the old in the 2nd part of the patch below 

I think that all the (priv->hw_rev == RTL8187BvB) stuff is still there - I just
moved it to the min/max definitions, but I'll take another look.

Larry

