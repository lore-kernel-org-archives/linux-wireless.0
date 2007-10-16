Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:8560 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXJPA1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 20:27:41 -0400
Received: by py-out-1112.google.com with SMTP id u77so3355021pyb
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 17:27:41 -0700 (PDT)
Message-ID: <43e72e890710151727s74beb476h4e5d49fe6840117c@mail.gmail.com> (sfid-20071016_012746_155401_E2CF12A0)
Date: Mon, 15 Oct 2007 20:27:40 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John Daiker" <daikerjohn@gmail.com>
Subject: Re: Ath5k compile error in wireless-2.6.git
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4713EBCA.8010700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4713EBCA.8010700@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/07, John Daiker <daikerjohn@gmail.com> wrote:
> John,
>
> I just checked out the wireless-2.6.git tree from Kernel.org to test the
> new ath5k driver. I get the following compile error on a 'vanilla'
> git-clone.
>
> CC [M] drivers/net/wireless/ath5k/base.o
> In file included from drivers/net/wireless/ath5k/base.h:49,
> from drivers/net/wireless/ath5k/base.c:58:
> drivers/net/wireless/ath5k/ath5k.h:213: error: redeclaration of
> enumerator 'MODE_ATHEROS_TURBO'
> include/net/mac80211.h:105: error: previous definition of
> 'MODE_ATHEROS_TURBO' was here
> drivers/net/wireless/ath5k/ath5k.h:215: error: redeclaration of
> enumerator 'MODE_ATHEROS_TURBOG'
> include/net/mac80211.h:107: error: previous definition of
> 'MODE_ATHEROS_TURBOG' was here
> drivers/net/wireless/ath5k/base.c: In function 'ath_configure_filter':
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_PROMISC_IN_BSS'
> undeclared (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: (Each undeclared
> identifier is reported only once
> drivers/net/wireless/ath5k/base.c:1419: error: for each function it
> appears in.)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_ALLMULTI' undeclared
> (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_FCSFAIL' undeclared
> (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_PLCPFAIL' undeclared
> (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_CONTROL' undeclared
> (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_OTHER_BSS'
> undeclared (first use in this function)
> drivers/net/wireless/ath5k/base.c:1419: error: 'FIF_BCN_PRBRESP_PROMISC'
> undeclared (first use in this function)
> drivers/net/wireless/ath5k/base.c: At top level:
> drivers/net/wireless/ath5k/base.c:1479: warning: 'enum set_key_cmd'
> declared inside parameter list
> drivers/net/wireless/ath5k/base.c:1479: warning: its scope is only this
> definition or declaration, which is probably not what you want
> drivers/net/wireless/ath5k/base.c:1477: error: parameter 2 ('cmd') has
> incomplete type
> drivers/net/wireless/ath5k/base.c:1583: error: unknown field 'start'
> specified in initializer
> drivers/net/wireless/ath5k/base.c:1584: warning: initialization from
> incompatible pointer type
> drivers/net/wireless/ath5k/base.c:1589: error: unknown field
> 'configure_filter' specified in initializer
> drivers/net/wireless/ath5k/base.c:1589: warning: initialization from
> incompatible pointer type
> drivers/net/wireless/ath5k/base.c:1590: warning: initialization from
> incompatible pointer type
> make[4]: *** [drivers/net/wireless/ath5k/base.o] Error 1
> make[3]: *** [drivers/net/wireless/ath5k] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
>
>
> Maybe you can shed some light?

Please use the 'everything' branch, not the 'ath5k' branch. This is
reflected on the wiki:

http://linuxwireless.org/en/users/Drivers/ath5k

  Luis
