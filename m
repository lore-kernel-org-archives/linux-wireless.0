Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:52506 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1LJQVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 11:21:22 -0500
Received: from il93mgrg01.am.mot-mobility.com ([10.176.130.20])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id pB94pe3I008747
	for <linux-wireless@vger.kernel.org>; Thu, 8 Dec 2011 23:51:41 -0500 (EST)
Received: from mail-vw0-f47.google.com (mail-vw0-f47.google.com [209.85.212.47])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id pB94peXT008738
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 8 Dec 2011 23:51:40 -0500 (EST)
Received: by vbbfc21 with SMTP id fc21so2807170vbb.34
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 20:56:51 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Dec 2011 10:26:51 +0530
Message-ID: <CAPSXAjdTHKC7wxPXsS2VVNSJcgaWDTQSNBYQhfbog6--uHkDvg@mail.gmail.com> (sfid-20111210_172125_805837_F22BD61F)
Subject: modprobe utility not found
From: PRASHANTH CHAKRAVARTHY <a19110@motorola.com>
To: linux-wireless@vger.kernel.org
Cc: Sireesha Kosuri <jmng34@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
We are trying to build compat utility on mac os machines. Builds are
failing there with error /sbin/modprobe not found. They are passing on
other linux machines .
Is there a modprobe utility for mac os machines ?

Regards,
Prashanth
