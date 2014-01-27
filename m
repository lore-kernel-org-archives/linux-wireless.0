Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52793 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaA0Ade (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 19:33:34 -0500
Received: by mail-oa0-f50.google.com with SMTP id n16so6110538oag.9
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 16:33:34 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 27 Jan 2014 08:33:33 +0800
Message-ID: <CAKH5=LtHebwAigBVvLOgBz-nv9RRGWLo6=kz5XOWqua1yCuyuA@mail.gmail.com> (sfid-20140127_013402_644542_9DB2F8DF)
Subject: have any others tools to test the wifi moduels throughput ???
From: Naughtboy <skylvlinux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi   bigboy



when i try transplant iperf3 into mips platform ,but  ocuur the follow errors

iperf3_profile-tcp_window_size.o iperf3_profile-timer.o
iperf3_profile-units.o  libiperf.a
/opt/toolchains/stbgcc-4.5.3-2.4/bin/../lib/gcc/mipsel-linux-uclibc/4.5.3/../../../../mipsel-linux-uclibc/bin/ld:
gcrt1.o: No such file: No such file or directory
collect2: ld returned 1 exit status
make[2]: *** [iperf3_profile] Error 1
in the recently i use iperf3 in the mips broad ,but here ocuur erros
: error - unable to receive parameters from client: Cannot allocate memory

# iperf 3 -s -i1     // it run in  the   mips broad

-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
iperf3: error - unable to receive parameters from client: Cannot allocate memory

 # bin/iperf3.exe -c 192.168.100.102 -u -P 1 -i 1 -p 5201 -f m -b 1.0M
-t 10  // it run in the pc


bin/iperf3.exe -c 192.168.100.102 -u -P 1 -i 1 -p 5201 -f m -b 1.0M -t 10
Connecting to host 192.168.100.102, port 5201
error: Unable to receive control message: Connection reset by peer
Done.


which make crazy , these erros  ,did you has a sulotions ????

thankyou  advance !!
