Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65239 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbZASDNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 22:13:36 -0500
Subject: Re: [Orinoco-devel] [PATCH] Move orinoco Kconfig entries in
 drivers/net/wireless/orinoco/Kconfig
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200901171554.00061.arvidjaar@mail.ru>
References: <200901171554.00061.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 22:13:31 -0500
Message-Id: <1232334811.5609.34.camel@dv> (sfid-20090119_041341_939080_D118DC82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-17 at 15:53 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] Move orinoco Kconfig entries in 
> drivers/net/wireless/orinoco/Kconfig
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Since driver now lives in separate subdirectory, move Kconfig entries
> in own file so they can be tweaked indepndently. It complements commit
> b2e53b338b7b4608372d070bb477f3bae3971e5a.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
