Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52609 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810Ab2LEUxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:53:15 -0500
Message-ID: <1354740752.6234.85.camel@cumari.coelho.fi> (sfid-20121205_215325_998852_BC8E3E7D)
Subject: Re: [PATCH 09/20] wlcore: disable elp sleep while in plt mode
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Yair Shapira <yair.shapira@ti.com>
Date: Wed, 5 Dec 2012 22:52:32 +0200
In-Reply-To: <1354095769-8724-10-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-10-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Yair Shapira <yair.shapira@ti.com>
> 
> We now disable elp sleep during plt mode to allow normal operation of
> plt tools such as calibrator.
> 
> Having elp_sleep enabled during plt mode is actually not required and
> in fact it disrupt plt operations such as rx statistics etc...

Has this really been observed in practice? At least what I remember is
that we use CAM power mode in PLT (during init) so we never get to ELP
mode.


> This is based on wl12xx (R5) commit 5cf0fe31ab

This is residue from internal code and is meaningless in the mainline.

--
Luca.

