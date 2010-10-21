Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64239 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0JUQSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 12:18:14 -0400
Received: by fxm16 with SMTP id 16so224854fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 09:18:13 -0700 (PDT)
MIME-Version: 1.0
From: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Date: Thu, 21 Oct 2010 14:17:52 -0200
Message-ID: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
Subject: Modifying the driver iwlwifi
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

  I'm a masters student of Automation and Systems Engineering at
Federal University of Santa Catarina in Brazil. I'd like to know if it
is possible to modify the implementation of iwlwifi because I need to
decrease the time of association between the client and the AP. I'd
like to implement something in the same way like I read in an article,
project QuickWifi. Its basic idea is that a client doesn't wait each
response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
an end-to-end connection is available.

    I need this to my work, it will be used for the communication
between a moving vehicle and a fixed point on the street.

Thank you.

Best regards,

-
Cassiano Valle Tartari
Computer Engineer

Tel: +55.48.84474818
Email: falecom@cassianotartari.eng.br
Site: http://www.cassianotartari.eng.br
