Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:54984 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1HPAOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 20:14:02 -0400
Received: by iye16 with SMTP id 16so8449335iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 17:14:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 17:14:01 -0700
Message-ID: <CAFHVRfdha1e-+E+hTKPv2JAu5ywOkNo+we2k5FUGtdtRDTV4Aw@mail.gmail.com> (sfid-20110816_021406_439461_B0A76827)
Subject: Problem Building carl9170
From: Panu Avakul <avakulpa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I was trying to build carl9170 firmware from the source on the
git repository.
The toolchain build with no problem.
However, when I run autogen.sh
it give me a cmake error message
CMake Error: Parse error in cache file
/home/radius0014/carl9170fw/config/CMakeCache.txt.
I tried deleting it and re run autogen.sh but still no different.
I was wondering if any one had similar problem and any advice on how I
should resolve it.
I am running this on ubuntu 11.04
Thank you very much
Best Regard,
Panu
