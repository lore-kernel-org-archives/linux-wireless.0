Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:50405 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZAWNaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 08:30:22 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2142596yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 05:30:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 13:30:21 +0000
Message-ID: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com> (sfid-20090123_143030_485292_592B857C)
Subject: ath5k mesh in 2.6.28?
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

According to the 802.11s website it seems to claim that mesh
networking is supported for ath5k devices in kernel 2.6.28, however,
upon running ifconfig mesh0 up (having previously created the mesh
device using iw) I get "SIOCSIFFLAGS: Operation not supported".  I
have made sure to compile my kernel with the o11s stack, and a
previous wireless-testing kernel had mesh working on the same
hardware.  Anyone have any idea as to what might be wrong?

Cheers

Keir
