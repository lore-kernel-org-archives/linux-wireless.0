Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aliencamel.com ([69.93.184.242]:34731 "EHLO aliencamel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYBVPYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:24:03 -0500
Received: from [212.238.154.110] (account timothyr HELO [192.168.1.21])
  by aliencamel.com (CommuniGate Pro SMTP 4.2.10)
  with ESMTP-TLS id 56141775 for linux-wireless@vger.kernel.org; Fri, 22 Feb 2008 14:24:01 +0000
Subject: does not build iplwifi3945 in my 2.6.24 kernel.
From: Tim Richardson <tim@tim-richardson.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Feb 2008 15:24:09 +0100
Message-Id: <1203690249.9268.5.camel@d420> (sfid-20080222_152408_802004_483C21F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I downloaded the tarball today.

I want to build it against Debian 2.6.24

I get these errors from make


/home/tim/compat-wireless-2.6/drivers/net/wireless/ipw2200.c: In
function =E2=80=98ipw_tx_skb=E2=80=99:
/home/tim/compat-wireless-2.6/drivers/net/wireless/ipw2200.c:10352:
error: implicit declaration of function =E2=80=98le32_add_cpu=E2=80=99
make[3]: ***
[/home/tim/compat-wireless-2.6/drivers/net/wireless/ipw2200.o] Error 1
make[2]: *** [/home/tim/compat-wireless-2.6/drivers/net/wireless] Error
2
make[1]: *** [_module_/home/tim/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
make: *** [modules] Error 2


Am I doing something wrong?

regards
Tim


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
