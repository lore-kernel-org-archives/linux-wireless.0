Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:48680 "EHLO
	smtp-35.italiaonline.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaLDTJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 14:09:46 -0500
Date: Thu, 4 Dec 2014 20:01:25 +0100 (CET)
From: m_del_buon@libero.it
To: linux-wireless@vger.kernel.org
Message-ID: <19484232.27307.1417719685831.JavaMail.httpd@fep-mail-gateway-l2b.virgilio.net> (sfid-20141204_200949_943448_9210AB7B)
Subject: help
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_26589_24824533.1417718615200"
Reply-To: m_del_buon@libero.it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_26589_24824533.1417718615200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

can you help me with this problems? thx

Sent from Libero Mobile
________________________________

Il 04/12/2014, m_del_buon@libero.it ha scritto:

hi I am an italian user of one realtek based device Bus 001 Device 005: ID =
0df6:004b Sitecom Europe B.V. WL-349v3 Wireless Micro Adapter 150N X1 [Real=
tek RTL8192SU] on an ubuntu 14.04 64bit 3.13.0-40-generic kernel and I rece=
ived following error
make
make -C /lib/modules/3.13.0-40-generic/build M=3D/home/hp/rtl8192su-master/=
rtlwifi CONFIG_RTL_CARDS=3Dy CONFIG_RTLWIFI=3Dm CONFIG_RTLWIFI_DEBUG=3Dy CO=
NFIG_RTLWIFI_DEBUGFS=3Dy CONFIG_RTLWIFI_USB=3Dm CONFIG_RTLWIFI_PCI=3Dm CONF=
IG_RTL8192SU=3Dm CONFIG_RTL8192SE=3Dm CONFIG_RTL8192S_COMMON=3Dm CONFIG_RTL=
8192CU=3Dn CONFIG_RTL8192DE=3Dn CONFIG_RTL8192CE=3Dn CONFIG_RTL8192C_COMMON=
=3Dn CONFIG_RTL8723AE=3Dn CONFIG_RTL8188EE=3Dn  EXTRA_CFLAGS=3D"-DDEBUG -DC=
ONFIG_RTLWIFI_DEBUGFS=3Dm -w"
make[1]: ingresso nella directory "/usr/src/linux-headers-3.13.0-40-generic=
"
  CC [M]  /home/hp/rtl8192su-master/rtlwifi/regd.o
In file included from include/net/cfg80211.h:23:0,
                 from include/net/mac80211.h:21,
                 from /home/hp/rtl8192su-master/rtlwifi/wifi.h:41,
                 from /home/hp/rtl8192su-master/rtlwifi/regd.c:30:
/home/hp/rtl8192su-master/rtlwifi/regd.c:62:4: error: =E2=80=98NL80211_RRF_=
NO_IR=E2=80=99 undeclared here (not in a function)
    NL80211_RRF_NO_IR)
    ^
include/net/regulatory.h:128:11: note: in definition of macro =E2=80=98REG_=
RULE=E2=80=99
  .flags =3D reg_flags,    \
           ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:99:6: note: in expansion of macro =
=E2=80=98RTL819x_2GHZ_CH12_13=E2=80=99
      RTL819x_2GHZ_CH12_13,
      ^
/home/hp/rtl8192su-master/rtlwifi/regd.c: In function =E2=80=98_rtl_reg_app=
ly_beaconing_flags=E2=80=99:
/home/hp/rtl8192su-master/rtlwifi/regd.c:186:20: error: =E2=80=98IEEE80211_=
CHAN_NO_IR=E2=80=99 undeclared (first use in this function)
      ch->flags &=3D ~IEEE80211_CHAN_NO_IR;
                    ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:186:20: note: each undeclared iden=
tifier is reported only once for each function it appears in
/home/hp/rtl8192su-master/rtlwifi/regd.c: In function =E2=80=98_rtl_reg_app=
ly_active_scan_flags=E2=80=99:
/home/hp/rtl8192su-master/rtlwifi/regd.c:214:19: error: =E2=80=98IEEE80211_=
CHAN_NO_IR=E2=80=99 undeclared (first use in this function)
   if (ch->flags & IEEE80211_CHAN_NO_IR)
                   ^
/home/hp/rtl8192su-master/rtlwifi/regd.c: In function =E2=80=98_rtl_reg_app=
ly_radar_flags=E2=80=99:
/home/hp/rtl8192su-master/rtlwifi/regd.c:279:10: error: =E2=80=98IEEE80211_=
CHAN_NO_IR=E2=80=99 undeclared (first use in this function)
          IEEE80211_CHAN_NO_IR;
          ^
/home/hp/rtl8192su-master/rtlwifi/regd.c: In function =E2=80=98_rtl_regd_in=
it_wiphy=E2=80=99:
/home/hp/rtl8192su-master/rtlwifi/regd.c:348:7: error: =E2=80=98struct wiph=
y=E2=80=99 has no member named =E2=80=98regulatory_flags=E2=80=99
  wiphy->regulatory_flags |=3D REGULATORY_CUSTOM_REG;
       ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:348:29: error: =E2=80=98REGULATORY=
_CUSTOM_REG=E2=80=99 undeclared (first use in this function)
  wiphy->regulatory_flags |=3D REGULATORY_CUSTOM_REG;
                             ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:349:7: error: =E2=80=98struct wiph=
y=E2=80=99 has no member named =E2=80=98regulatory_flags=E2=80=99
  wiphy->regulatory_flags &=3D ~REGULATORY_STRICT_REG;
       ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:349:30: error: =E2=80=98REGULATORY=
_STRICT_REG=E2=80=99 undeclared (first use in this function)
  wiphy->regulatory_flags &=3D ~REGULATORY_STRICT_REG;
                              ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:350:7: error: =E2=80=98struct wiph=
y=E2=80=99 has no member named =E2=80=98regulatory_flags=E2=80=99
  wiphy->regulatory_flags &=3D ~REGULATORY_DISABLE_BEACON_HINTS;
       ^
/home/hp/rtl8192su-master/rtlwifi/regd.c:350:30: error: =E2=80=98REGULATORY=
_DISABLE_BEACON_HINTS=E2=80=99 undeclared (first use in this function)
  wiphy->regulatory_flags &=3D ~REGULATORY_DISABLE_BEACON_HINTS;
                              ^
make[2]: *** [/home/hp/rtl8192su-master/rtlwifi/regd.o] Errore 1
make[1]: *** [_module_/home/hp/rtl8192su-master/rtlwifi] Errore 2
make[1]: uscita dalla directory "/usr/src/linux-headers-3.13.0-40-generic"
make: *** [all] Errore 2
can you help me?

Sent from Libero Mobile
------=_Part_26589_24824533.1417718615200--
