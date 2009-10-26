Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.a8.com ([203.129.83.115]:37898 "EHLO mail3.a8.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbZJZCtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 22:49:05 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail3.a8.com (Postfix) with ESMTP id 25A1A1FB6D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 10:33:32 +0800 (CST)
Received: from mail3.a8.com ([127.0.0.1])
	by localhost (mail2.a8.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DR9H63d5Wt+t for <linux-wireless@vger.kernel.org>;
	Mon, 26 Oct 2009 10:33:31 +0800 (CST)
Received: from mail.a8.com (mail.a8.com [192.168.0.19])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail3.a8.com (Postfix) with ESMTP id C6FC71FB5E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 10:33:31 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.a8.com (Postfix) with ESMTP id 3FB67400058
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 10:32:48 +0800 (CST)
Received: from mail.a8.com ([127.0.0.1])
	by localhost (mail.a8.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 68OMIrgT0uNC for <linux-wireless@vger.kernel.org>;
	Mon, 26 Oct 2009 10:32:47 +0800 (CST)
Received: from a8.com (mail1.a8.com [192.168.0.18])
	by mail.a8.com (Postfix) with ESMTP id E1A3F400056
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 10:32:47 +0800 (CST)
Message-ID: <20091026103247.2ng5wbub4ow8ok4w@webmail.yy.com>
Date: Mon, 26 Oct 2009 10:32:47 +0800
From: belle.shi@yy.com
To: linux-wireless@vger.kernel.org
Subject: about 802.11 scan and probe request
MIME-Version: 1.0
Content-Type: text/plain;
	charset=GB2312;
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dear all,
   is there anyone who read the standard "Part 11: Wireless LAN Medium
Access Control (MAC) and Physical Layer (PHY) Specifications" ?
   and i spend two month to read the stardard, and i read a few code of 
wpa_suppliant and
wpa_gui,there is one question: the scan have two mode:active or 
passive,but when i run
the wpa_gui, there is only scan button, in the standard the scan 
request is like
MLME-SCAN.request (
                 BSSType,
                 BSSID,
                 SSID,
                 ScanType,
                 ProbeDelay,
                 ChannelList,
                 MinChannelTime,
                 MaxChannelTime
                 )
but there are only three MAC frame formats:data frame, control frame 
and Management
frame, and there is no scan frame, there is only a Probe Request frame, 
    so i am
stumped, what's the relationship between MLME-SCAN.request and Probe 
Request frame, is
the MLME-SCAN.request and Probe Request frame only in different layer? 
but the items is
also different, the MLME-SCAN.request have:(
BSSType, BSSID, SSID,  ScanType, ProbeDelay,  ChannelList,  
MinChannelTime,   MaxChannelTime), but the  Probe Request frame body 
only have two parts:  SSID
and Supported rates.     and in my view, i think the active scan is to 
send Probe Request
frame, and the passive scan to receive the beacon frame, is it right?
    thanks very much for advance!!
belle

