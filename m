Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:37046 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbaDBOWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 10:22:53 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so258556yhl.20
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2014 07:22:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Apr 2014 17:22:52 +0300
Message-ID: <CAE_+Soz6Vdvw0Q=HRYpQY2o9DimebhKbifEtYf-LPb+nyWDX7Q@mail.gmail.com> (sfid-20140402_162257_046102_CF4493B1)
Subject: Interaction 802.2 LLC and 802.11 MAC
From: Mathieu Devos <mathieu.dvs@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

In light of research on WiFi I have run into quite some problems when
it comes to the WiFi stack. I'm currently a student doing research for
my Master Thesis and in this context I am trying to write a
specification for a new Internet (Recurse InterNetworking
Architecture, RINA). In this Master Thesis I'm writing I have a
chapter on how his new Architecture should be handled over WiFi. For
this I'm basing myself on the 802.11 IEEE standard (2012) for the MAC
header and the 802.2 standard (1998) for the LLC header. Now I have
run into an issue is that I cannot find any information on how the
interaction between the LLC and MAC header is happening. Furthermore I
seem to be unable to determine how SAP (both SSAP & DSAP) are assigned
to interfaces.
Furthermore is the use of QoS-cubes very confusing in this 802.11
standard and trying to map them seems a terribly complicated.

For this new architecture we are planning on only using Type 1
operation of LLC, because this requires the non-ACKing mode. Even
though Type 2 Operation seems more favorable because this actually
provides data link connection. Due to the requirement of permanent
ACKing of LLC PDUs this seems non favorable (especially since the
sequence number is limited to 128).

While I am aware that drivers (or hardware) transform these WiFi
headers to general Ethernet (802.3) packets and present them as such
to the kernel, this is a purely theoretical chapter and will not have
any actual coding implication. At least not for a while...

If any information on this could be provided, or any direction as to
where to get this information, I would be very grateful.


Kind regards,
Mathieu Devos
