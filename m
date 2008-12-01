Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38401 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYLAWBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 17:01:15 -0500
Date: Mon, 1 Dec 2008 16:58:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: nl80211 not found
Message-ID: <20081201215851.GD3479@tuxdriver.com> (sfid-20081201_230119_216161_91B38051)
References: <4934563D.5080703@telecom-sudparis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4934563D.5080703@telecom-sudparis.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 10:25:17PM +0100, Chanthearith HUON wrote:
> Hello everyone,
>
> I recently installed command "iw" in order to use mesh capability in my  
> wireless card.
> iw itself and its required library were installed successfully. But  
> whenever I run the command "iw", this message appears "nl80211 not 
> found."
>
> My linux is ubuntu 8.10 Intrepid Ibex with kernel 2.6.27
> My wireless card: Pro/wireless 2200BG Network connection with ipw2200  
> driver.
>
> Can you give me some suggestions?

Your hardware does not support mesh mode, and the driver doesn't
support nl80211 anyway.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
