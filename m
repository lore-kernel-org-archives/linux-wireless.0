Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:60639 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2I1Itu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 04:49:50 -0400
Message-ID: <1348822162.15949.4.camel@cumari.coelho.fi> (sfid-20120928_104954_641300_A439E268)
Subject: Re: [PATCH] wl18xx: use module_platform_driver
From: Luciano Coelho <luca@coelho.fi>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>, Ido Reis <idor@ti.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 28 Sep 2012 11:49:22 +0300
In-Reply-To: <1346261581-21613-1-git-send-email-devendra.aaru@gmail.com>
References: <1346261581-21613-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-29 at 23:03 +0530, Devendra Naga wrote:
> the driver's init and exit routines can be implemented with the
> module_platform_driver, as the init and exit code is same as
> that of the module_platform_driver
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---

Applied, thanks!

--
Luca.

