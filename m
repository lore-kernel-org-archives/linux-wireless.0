Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:57344 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab1A0Rib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 12:38:31 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0RHcMIk009114
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 12:38:25 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 36B0098517
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 12:38:22 -0500 (EST)
Message-ID: <4D41AD8E.5040500@lockie.ca>
Date: Thu, 27 Jan 2011 12:38:22 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Unspecified failure
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How can I find out what the "Unspecified failure" is?


$ sudo iw --debug dev wlan1 connect -w "test"     
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 164
    .nlmsg_type = 18 <0x12>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 0
    .nlmsg_pid = 0
  [PAYLOAD] 148 octets
    21 01 00 00 08 00 01 00 00 00 00 00 08 00 03 00 03 00 !.................
    00 00 0c 00 2d 00 08 00 00 00 74 65 73 74 74 00 2c 00 ....-.....testt.,.
    08 00 00 00 6c 09 00 00 08 00 01 00 71 09 00 00 08 00 ....l.......q.....
    02 00 76 09 00 00 08 00 03 00 7b 09 00 00 08 00 04 00 ..v.......{.......
    80 09 00 00 08 00 05 00 85 09 00 00 08 00 06 00 8a 09 ..................
    00 00 08 00 07 00 8f 09 00 00 08 00 08 00 94 09 00 00 ..................
    08 00 09 00 99 09 00 00 08 00 0a 00 9e 09 00 00 08 00 ..................
    0b 00 a3 09 00 00 08 00 0c 00 a8 09 00 00 08 00 0d 00 ..................
    b4 09 00 00                                           ....
---------------------------  END NETLINK MESSAGE  
---------------------------
-- Error: Invalid message: type=0x12 length=164 flags=<> sequence-nr=0 pid=0
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 36
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1296149664
    .nlmsg_pid = 2927
  [ERRORMSG] 20 octets
    .error = 0 "Success"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 18 <0x12>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1296149664
    .nlmsg_pid = 2927
---------------------------  END NETLINK MESSAGE  
---------------------------
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 164
    .nlmsg_type = 18 <0x12>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 0
    .nlmsg_pid = 0
  [PAYLOAD] 148 octets
    22 01 00 00 08 00 01 00 00 00 00 00 08 00 03 00 03 00 ".................
    00 00 0c 00 2d 00 08 00 00 00 74 65 73 74 74 00 2c 00 ....-.....testt.,.
    08 00 00 00 6c 09 00 00 08 00 01 00 71 09 00 00 08 00 ....l.......q.....
    02 00 76 09 00 00 08 00 03 00 7b 09 00 00 08 00 04 00 ..v.......{.......
    80 09 00 00 08 00 05 00 85 09 00 00 08 00 06 00 8a 09 ..................
    00 00 08 00 07 00 8f 09 00 00 08 00 08 00 94 09 00 00 ..................
    08 00 09 00 99 09 00 00 08 00 0a 00 9e 09 00 00 08 00 ..................
    0b 00 a3 09 00 00 08 00 0c 00 a8 09 00 00 08 00 0d 00 ..................
    b4 09 00 00                                           ....
---------------------------  END NETLINK MESSAGE  
---------------------------
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 52
    .nlmsg_type = 18 <0x12>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 0
    .nlmsg_pid = 0
  [PAYLOAD] 36 octets
    25 01 00 00 08 00 01 00 00 00 00 00 08 00 03 00 03 00 %.................
    00 00 04 00 41 00 0a 00 06 00 00 18 3f b6 7d 69 00 00 ....A.......?.}i..
---------------------------  END NETLINK MESSAGE  
---------------------------
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 56
    .nlmsg_type = 18 <0x12>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 0
    .nlmsg_pid = 0
  [PAYLOAD] 40 octets
    2e 01 00 00 08 00 01 00 00 00 00 00 08 00 03 00 03 00 ..................
    00 00 0a 00 06 00 00 18 3f b6 7d 69 00 00 06 00 48 00 ........?.}i....H.
    01 00 00 00                                           ....
---------------------------  END NETLINK MESSAGE  
---------------------------
wlan1 (phy #0): failed to connect to 00:18:3f:b6:7d:69, status: 1:
Unspecified failure

