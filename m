Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.store20.com ([212.7.7.16]:53529 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYDXMNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 08:13:05 -0400
Subject: Re: [PATCH] iwlwifi: Select also LEDS_TRIGGERS.
From: Priit Laes <plaes@plaes.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
	reinette.chatre@intel.com
In-Reply-To: <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com>
References: <1209033767.1368.3.camel@localhost>
	 <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 Apr 2008 15:12:59 +0300
Message-Id: <1209039179.3777.0.camel@localhost> (sfid-20080424_141344_906231_F4B66197)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=C3=9Chel kenal p=C3=A4eval, N, 2008-04-24 kell 14:24, kirjutas Tomas W=
inkler:
> Shouldn't be this already covered by MAC80211_LEDS
>=20
> 	depends on IWL4965
>  	select MAC80211_LEDS
>  	select LEDS_CLASS
> +	select LEDS_TRIGGERS
>  	select IWLWIFI_LEDS

Compile failed for me until I selected LEDS_TRIGGERS myself.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
