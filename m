Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout4.uol.com.br ([200.221.4.195]:45321 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757115Ab0ERIzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 04:55:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by socom4.uol.com.br (Postfix) with ESMTP id 1E901E0000A3
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 05:55:45 -0300 (BRT)
Received: from chagas.nectar.ath.cx (unknown [187.22.165.163])
	(Authenticated sender: rogerbrito@uol.com.br)
	by socom4.uol.com.br (Postfix) with ESMTPA id F0934E0000A2
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 05:55:41 -0300 (BRT)
Date: Tue, 18 May 2010 05:55:42 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rndis_wlan: replace wireless_send_event with
 cfg80211_disconnected in rndis_wlan_do_link_down_work
Message-ID: <20100518085542.GB18928@ime.usp.br>
References: <20100518082051.18988.85196.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20100518082051.18988.85196.stgit@fate.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Jussi.

On May 18 2010, Jussi Kivilinna wrote:
> Remove (hopefully) last use of WEXT in rndis_wlan. Replace wireless_send_event
> with missing cfg80211_disconnected in rndis_wlan_do_link_down_work.

Thanks. Should this be sent to stable?


Regards,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 1024D/7C2CAEB8
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
