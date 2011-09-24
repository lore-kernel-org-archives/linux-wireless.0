Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:49844 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab1IXDaR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 23:30:17 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p8O3UD3r008223
	for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 23:30:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 828181E0144
	for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 23:30:12 -0400 (EDT)
Message-ID: <4E7D4EC4.2040506@lockie.ca> (sfid-20110924_053027_366464_E0D1D4AF)
Date: Fri, 23 Sep 2011 23:30:12 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: higher N rates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

$ iw dev wlan0 scan

printed this for my N (only) router:

Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0
Extended supported rates: 6.0 9.0 12.0 48.0

Why doesn't it print the higher N rates?
