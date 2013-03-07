Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55581 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3CGDYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 22:24:14 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so4365eek.29
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 19:24:12 -0800 (PST)
Message-ID: <5138085A.5090800@gmail.com> (sfid-20130307_042419_751459_E3A78005)
Date: Thu, 07 Mar 2013 04:24:10 +0100
From: Jenya Y <jy.gerstmaier@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to connect
 to any available hotspots.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Even though I am presented with a list of available networks, my system 
with the rc1 kernel is not able to connect to any of them.
It stops at the point where it tries to obtain an IP address.

I tried to delete the Profile of my WiFi and recreate it but no luck.

This issue is only with 3.9rc1, it worked fine with 3.6 to 3.8.2.

