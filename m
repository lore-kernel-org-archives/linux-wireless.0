Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752911AbZBYAwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 19:52:25 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 25 Feb 2009 01:52:22 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090225004955.227080@gmx.net>
Message-ID: <20090225005222.227050@gmx.net> (sfid-20090225_015228_721859_80C9A0CC)
MIME-Version: 1.0
References: <20090221231800.227280@gmx.net>	
 (sfid-20090222_001831_559891_2537405E)
 <1235439633.4455.33.camel@johannes.local> <20090225004955.227080@gmx.net>
Subject: Re: [PATCH v3] mac80211: Give it some time to do the TSF sync
To: "Alina Friedrichsen" <x-alina@gmx.net>, johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.S.: You can test it with:

root@starbuck:~# echo reset > /sys/kernel/debug/ieee80211/phy0/tsf; cat=
 /sys/kernel/debug/ieee80211/phy0/tsf=20
0x0000000000000ca0
root@starbuck:~#=20

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
