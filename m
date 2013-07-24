Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:44372 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXTgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 15:36:48 -0400
Received: by mail-ob0-f194.google.com with SMTP id v19so3002196obq.9
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 12:36:47 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Jul 2013 12:36:46 -0700
Message-ID: <CAHS2MGP5LxXXec3-fHCY4d5g9+2bo+P8Ge6KHiDrVf2ZvbFrgA@mail.gmail.com> (sfid-20130724_213651_432450_E15CE9CB)
Subject: Lowest Supported Rate for Unicast Management Frame
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all

Just would like know is there any reason of having the unicast
management frame sent at lowest supported rate for the STA even if we
set the basic rate which could be higher than the lowest supported
rate for the STA.

-----
Chun-Yeow
