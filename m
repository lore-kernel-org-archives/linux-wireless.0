Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50703 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYKDNuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 08:50:37 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [RFC/RFT PATCH 0/2 v2] rtl8187: implement conf_tx callback/correctly ack tx pkts
Date: Tue,  4 Nov 2008 08:50:47 -0500
Message-Id: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> (sfid-20081104_145042_189201_3633E4EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two patches for two current issues in rtl8187:
- First it should implement conf_tx callback, instead of hardcoding some tx
  queue values.
- The second one should make rate control work for 8187B sending correct
  feedback about transmitted packet status, using one of the Bulk In endpoints
  that provides this info.

Please test and check if there are issues.
