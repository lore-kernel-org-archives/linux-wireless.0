Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46084 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbYFMQg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 12:36:56 -0400
Subject: Re: iwl3945 and WPA
From: Pavel Roskin <proski@gnu.org>
To: Maciek Kaliszewski <mkalkal@interia.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48527D72.4070509@interia.pl>
References: <4852658A.4040402@interia.pl>
	 <20080613132317.GB5333@tuxdriver.com>
	 <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>
	 <48527D72.4070509@interia.pl>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Jun 2008 12:36:54 -0400
Message-Id: <1213375014.29669.36.camel@dv> (sfid-20080613_183703_798196_FD150070)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-13 at 16:00 +0200, Maciek Kaliszewski wrote:

> debian:/home/u# dpkg -l |grep wpa
> ii  wpasupplicant                        0.6.3-1
> Client support for WPA and WPA2 (IEEE 802.11
>=20
> It is standard debian/lenny package .
> Should I compile wpa_supplicant from source ?
>=20
> On other computer debian/lenny also ,and p54pci.ko driver everything
> works ok.

=EF=BB=BFMake sure you don't have any obsolete version of wpa_supplican=
t in
PATH.

Try removing "scan_ssid=3D1".   Also try ESSID scanning in iwlist:
iwlist wlan0_rename scanning essid APTEKA

If the recompiled wpa_supplicant fails, try asking in
hostap@lists.shmoo.com (the list for wpa_supplicant and hostapd)

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
