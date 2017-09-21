Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:44732 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdIUSCD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 14:02:03 -0400
Received: by mail-qk0-f181.google.com with SMTP id b23so6580722qkg.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 11:02:03 -0700 (PDT)
MIME-Version: 1.0
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Thu, 21 Sep 2017 13:01:57 -0500
Message-ID: <CADsGw2Zax=r7QBGYPO+bs0BTmb+JUVZ-Y-X+_gfRrKj8tQy27Q@mail.gmail.com> (sfid-20170921_200207_935243_80982052)
Subject: Query on iw command to set txq params
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All

I am trying to apply the path mentioned below to set txq params using
iw command.

http://www.spinics.net/lists/linux-wireless/msg42585.html

But I am getting below error.

root@teste-VirtualBox:~/old_iw/iw-0.9.17# ./iw list | grep Wiphy
Wiphy mn00s05
Wiphy mn00s04
Wiphy mn00s03
Wiphy mn00s02
root@teste-VirtualBox:~/old_iw/iw-0.9.17#
root@teste-VirtualBox:~/old_iw/iw-0.9.17#
root@teste-VirtualBox:~/old_iw/iw-0.9.17#
root@teste-VirtualBox:~/old_iw/iw-0.9.17# ./iw --debug phy mn00s03 set
txq_params 1
configuring TX queue for VI
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE ---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 96
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1506013146
    .nlmsg_pid = 5328
  [ERRORMSG] 20 octets
    .error = -22 "Invalid argument"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 30 <0x1e>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1506013146
    .nlmsg_pid = 5328
---------------------------  END NETLINK MESSAGE   ---------------------------
command failed: Invalid argument (-22)
root@teste-VirtualBox:~/old_iw/iw-0.9.17#

I am using mininet wifi to create topology with 4 APs.

Could someone suggest how to proceed on this?

Best Regards
Phani
