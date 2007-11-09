Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36739 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbXKIBaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 20:30:07 -0500
Subject: Re: mac80211 and SIOCSIWAUTH
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?=D0=92=D0=B5=D1=82=D0=BE=D1=88=D0=BA=D0=B8=D0=BD_?=
	 =?UTF-8?Q?=D0=9D=D0=B8=D0=BA=D0=B8=D1=82=D0=B0?=
	<nvetoshkin@naumen.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47335980.4070103@naumen.ru>
References: <47335980.4070103@naumen.ru>
Content-Type: text/plain; charset=GB2312
Date: Fri, 09 Nov 2007 09:23:31 +0800
Message-Id: <1194571411.31257.340.camel@debian.sh.intel.com> (sfid-20071109_013014_867348_9F5CD87D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-11-08 at 23:46 +0500, =A7=A3=A7=D6=A7=E4=A7=E0=A7=EA=A7=DC=
=A7=DA=A7=DF =A7=AF=A7=DA=A7=DC=A7=DA=A7=E4=A7=D1 wrote:
> ap_scan=3D2
> network=3D{
>          ssid=3D"point1"
>          key_mgmt=3DWPA-EAP
>          scan_ssid=3D1
>          identity=3D"nvetoshkin"
>          proto=3DWPA2
>          eap=3DTLS
>          ca_cert=3D"/home/nekto/certificate.pem"
>          private_key=3D"/home/nekto/nvetoshkin.p12"
>          private_key_passwd=3D"nvetoshkin"
> }

Can you try ap_scan=3D1? Last time I check wpa_supplicant source, it se=
ems
it doesn't pass the bssid and frequency in the "ap_scan=3D2" case when =
it
is trying to associate. (of course I could be wrong).

Thanks,
-yi
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
