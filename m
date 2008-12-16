Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:30289 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYLPMFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 07:05:38 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1309781yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 04:05:37 -0800 (PST)
Message-ID: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com> (sfid-20081216_130552_415366_3E698795)
Date: Tue, 16 Dec 2008 12:05:37 +0000
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Mesh now completely broken on ath5k, latest git
Cc: "Andrey Yurovsky" <andrey@cozybit.com>, javier@cozybit.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having has no luck with an old rc6 version (basically all plink
packets were getting lost), I upgraded to the newest git (rc8) however
now when I run iw dev mesh0 station sump I don't see a single other
mesh point.  This would imply that presumably beaconing is broken?

Does anyone know a revision for which ath5k is properly working? I am
yet to find one that works on my system.

Cheers

Keir
