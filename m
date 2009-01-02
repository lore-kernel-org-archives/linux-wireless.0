Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 208-104-20-34.fmgh.2wcm.comporium.net ([208.104.20.34]:44678
	"EHLO router1.tdux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbZABXkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 18:40:46 -0500
From: "tduckett" <duck@tdux.com>
To: "'tduckett'" <duck@tdux.com>, <linux-wireless@vger.kernel.org>
References: 
Subject: RE: Error compiling.    Please help
Date: Fri, 2 Jan 2009 18:07:56 -0500
Message-ID: <000001c96d2e$f348af80$0200f00a@video1> (sfid-20090103_004050_829845_EDFDF915)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(How about now)  I never seem to be able to get things compiled=A0 This=
 is
what I get when I run make.=A0 What do I need to do to get this to work=
?



[root@router1 madwifi-0.9.4]# make
Checking requirements... ok.
Checking kernel configuration... ok.
make -C /lib/modules/2.6.27.5-41.fc9.i686/build SUBDIRS=3D/tmp/t/madwif=
i-0.9.4
modules
make[1]: Entering directory `/usr/src/kernels/2.6.27.5-41.fc9.i686'
  CC [M]  /tmp/t/madwifi-0.9.4/net80211/ieee80211_power.o
/tmp/t/madwifi-0.9.4/net80211/ieee80211_power.c: In function
'ieee80211_pwrsave':
/tmp/t/madwifi-0.9.4/net80211/ieee80211_power.c:240: error: implicit
declaration of function '__skb_append'
make[3]: *** [/tmp/t/madwifi-0.9.4/net80211/ieee80211_power.o] Error 1
make[2]: *** [/tmp/t/madwifi-0.9.4/net80211] Error 2
make[1]: *** [_module_/tmp/t/madwifi-0.9.4] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27.5-41.fc9.i686'
make: *** [modules] Error 2

Thank you in advance=20
Duck


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
