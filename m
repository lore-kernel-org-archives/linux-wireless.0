Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:36958 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0GFM2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:28:25 -0400
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Pazzo Da Legare <pazzodalegare@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 6 Jul 2010 14:28:15 +0200
Subject: RE: wl1271 firmware
Message-ID: <AC090B9732AB2B4DB7FF476E907FE66001067C0669@dnce02.ent.ti.com>
References: <AANLkTinOcy-n6EVzAasAJO1I2yNeWOiaCid0tGdxnuwa@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE660010673660C@dnce02.ent.ti.com>
	<AANLkTimcFgxOmw4oOa28unhmSpTt0jNacFKXRXycKKA9@mail.gmail.com>
 <AANLkTikWzx5SZUxZ9qg5Y9jY44YzZlDvs1kSwbFET76H@mail.gmail.com>
In-Reply-To: <AANLkTikWzx5SZUxZ9qg5Y9jY44YzZlDvs1kSwbFET76H@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I start from tiwlan.ini file for tiwlan driver to produce an nvs file.
> Could you please indicate values to use for the following parameters
> of struct wl1271_nvs_file: general_params.srf1[],
> general_params.srf2[], general_params.srf3[],
> dyn_radio_params_2[].params.degraded_low_to_normal_thr,
> dyn_radio_params_2[].params.normal_to_degraded_high_thr,
> dyn_radio_params_5[i].params.degraded_low_to_normal_thr,
> dyn_radio_params_5[i].params.normal_to_degraded_high_thr

Hi,
The tiwlan driver ini&NVS files has a different stature then the mac80211 NVS. The parameters you mentioned are RF parameters. 
I believe it will be the best to get the NVS that mach to the mac80211 (that I am pushing to get).
Regards,
Shahar  
       
