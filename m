Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub-lb2.unibe.ch ([130.92.0.83]:36087 "EHLO
	mailhub-lb2.unibe.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0HCQKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 12:10:33 -0400
Received: from localhost (scanhub-lb1.unibe.ch [130.92.5.65])
	by mailhub-lb2.unibe.ch (Postfix) with ESMTP id 9ABF749802E
	for <linux-wireless@vger.kernel.org>; Tue,  3 Aug 2010 18:10:31 +0200 (CEST)
Received: from mailhub-lb2.unibe.ch ([130.92.0.83])
	by localhost (scanhub-lb1.unibe.ch [130.92.5.65]) (amavisd-new, port 10024)
	with LMTP id bbxPBZFB6ZKj for <linux-wireless@vger.kernel.org>;
	Tue,  3 Aug 2010 18:10:29 +0200 (CEST)
Received: from mail.iam.unibe.ch (asterix.unibe.ch [130.92.64.4])
	by mailhub-lb2.unibe.ch (Postfix) with ESMTP id 9EE84C4B4D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Aug 2010 18:10:29 +0200 (CEST)
Received: from [130.92.64.14] (baghira [130.92.64.14])
	by mail.iam.unibe.ch (8.13.8+Sun/8.13.8) with ESMTP id o73GATqa020474
	for <linux-wireless@vger.kernel.org>; Tue, 3 Aug 2010 18:10:29 +0200 (MEST)
Message-ID: <4C583F71.8070009@iam.unibe.ch>
Date: Tue, 03 Aug 2010 18:10:25 +0200
From: Zhongliang Zhao <zhao@iam.unibe.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iw set channel failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

When using iw to set the channel of mesh nodes working in ad hoc 
mode(with iw-tool installed), I got error:

# iw --debug dev wlan1 set channel 5

-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE 
---------------------------
   [HEADER] 16 octets
     .nlmsg_len = 36
     .nlmsg_type = 2 <ERROR>
     .nlmsg_flags = 0 <>
     .nlmsg_seq = 947833964
     .nlmsg_pid = 2734
   [ERRORMSG] 20 octets
     .error = 0 "Success"
   [ORIGINAL MESSAGE] 16 octets
     .nlmsg_len = 16
     .nlmsg_type = 17 <0x11>
     .nlmsg_flags = 5 <REQUEST,ACK>
     .nlmsg_seq = 947833964
     .nlmsg_pid = 2734
---------------------------  END NETLINK MESSAGE   
---------------------------


Does someone know the possible reason?

Many thanks in advance.

p.s. iwconfig could work for this.

zzl
