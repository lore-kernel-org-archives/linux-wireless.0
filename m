Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55178 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab0JFFgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 01:36:17 -0400
Subject: RE: [PATCH 13/25] wl1271: Enable/disable 11a support based on INI
 configuration
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Gabay, Benzy" <benzyg@ti.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C135ADBA314@dlee04.ent.ti.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-14-git-send-email-luciano.coelho@nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C135ADBA314@dlee04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 08:36:00 +0300
Message-ID: <1286343360.11177.262.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 07:26 +0200, ext Gabay, Benzy wrote:
> Juuso ,
> I thought that there is no .ini in the 1271 MAC802.11 solution. 
> According to the code below you are deciding if it is "a" or not according to NVS file.
> 
> Is it a typo in your header description or did I get it wrong?

No typo, there is a configuration section inside the wl1271-nvs.bin
-file referred to as the "INI-section." That ini section configures
general parameters (including the dual-band support) and several
radio-parameters.

These INI-parameters are the only way for the driver to know whether
there is 11a RF support in the hardware or not.

-Juuso

> > Sent: Monday, September 27, 2010 3:38 AM
> > 
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > Instead of hardcoding 11a support, enable/disable driver support based
> > on
> > the dual-mode-select parameter in the nvs-file general paramters.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---



