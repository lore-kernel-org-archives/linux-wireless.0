Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:55886 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbbB0Hbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 02:31:38 -0500
Message-ID: <1425022290.11202.1.camel@coelho.fi> (sfid-20150227_083144_092470_3C56F73F)
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
Date: Fri, 27 Feb 2015 09:31:30 +0200
In-Reply-To: <1423998550-8829-1-git-send-email-eliad@wizery.com>
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, 2015-02-15 at 13:09 +0200, Eliad Peller wrote:
> When running with device-tree, we no longer have a board file
> that can set up the platform data for wlcore.
> Allow this data to be passed from DT.
> 
> For now, parse only the irq used. Other (optional) properties
> can be added later on.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I don't really care much, but why not just finalize the work I did a
couple of years ago?

http://mid.gmane.org/1375189476-21557-1-git-send-email-coelho@ti.com
http://mid.gmane.org/1375215668-29171-1-git-send-email-coelho@ti.com

IIRC there were just some minor comments there, but I never really got
to it because I left TI.

--
Luca.

