Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from violet.fr.zoreil.com ([92.243.8.30]:43291 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbcABPH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 10:07:58 -0500
Date: Sat, 2 Jan 2016 16:07:44 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 3/3] rsi: Replace variable initialisations by assignments
 in rsi_send_data_pkt()
Message-ID: <20160102150744.GA8926@electric-eye.fr.zoreil.com> (sfid-20160102_160822_161599_028B9A61)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5687E27C.8000909@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5687E27C.8000909@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> :
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 2 Jan 2016 15:25:34 +0100
> 
> Replace explicit initialisation for two local variables at the beginning
> by assignments.

It makes no sense for the 'adapter' variable.

-- 
Ueimor
