Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:59976 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYLNAE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 19:04:27 -0500
Received: by qw-out-2122.google.com with SMTP id 3so492975qwe.37
        for <linux-wireless@vger.kernel.org>; Sat, 13 Dec 2008 16:04:26 -0800 (PST)
Message-ID: <99a2c9180812131604v41109e2ckc5c76f8f415ae8c9@mail.gmail.com> (sfid-20081214_010504_643057_3BD56F0F)
Date: Sun, 14 Dec 2008 02:04:26 +0200
From: "Ionut Radu" <ionut.radu@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: The latest archive is missing ath5k driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have installed the compat-wireless-2008-12-11, but I couldn't find
the ath5k driver :

ionut@mendol:~/compat-wireless-2008-12-11$ sudo modprobe ath5k
FATAL: Module ath5k not found.
ionut@mendol:~/compat-wireless-2008-12-11$ sudo athload ath5k
Module ath_pci not detected -- this is fine
FATAL: Module ath5k not found.
ionut@mendol:~/compat-wireless-2008-12-11$


What's wrong?

thanks,
Ionut Radu.
