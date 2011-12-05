Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63143 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab1LELzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 06:55:31 -0500
Received: by faar15 with SMTP id r15so460084faa.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 03:55:30 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 5 Dec 2011 17:25:30 +0530
Message-ID: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com> (sfid-20111205_125535_261000_FC029439)
Subject: Query on ieee80211_subif_start_xmit
From: uday kiran <kaniki.uday@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi List

 The function ieee80211_subif_start_xmit description says that it will
 encapsulate 802.3 frame with 802.11 header and transmit. If yes, what
 is the function which will decapsulate at the rx end.

 ieee80211_data_to_8023 replaces 802.11 header with 802.3 but it will
 not decapsulate.

 Is my understanding right ? Please clarify ?


 -Uday
