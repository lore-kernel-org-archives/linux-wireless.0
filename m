Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50746 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3LQGu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 01:50:59 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so5686338wgg.16
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 22:50:57 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 17 Dec 2013 12:20:37 +0530
Message-ID: <CABPxzYJSBagxbz4nd8=Qt_HbG4ecqe=-cbzi0N4JDPCwDE42Mg@mail.gmail.com> (sfid-20131217_075102_353968_914A31FF)
Subject: CRDA: Build Fail: Database signature verification failed
To: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@do-not-panic.com>
Cc: wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

With the latest git source, i am seeing a build failure with the below error.

  LD   crda
  CC   intersect.o
  LD   intersect
  CC   regdbdump.o
  LD   regdbdump
  CC   db2rd.o
  LD   db2rd
  CC   optimize.o
  LD   optimize
  CHK  /usr/lib/crda/regulatory.bin
Database signature verification failed.
Invalid or empty regulatory file, note: a binary regulatory file should be used.
make: *** [verify] Error 234

Is there something wrong with the certificate?

-- 
Thanks,
Regards,
Chaitanya T K.
