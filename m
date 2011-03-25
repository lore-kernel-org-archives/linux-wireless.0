Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57377 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1CYHme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 03:42:34 -0400
Received: by fxm17 with SMTP id 17so907145fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 00:42:33 -0700 (PDT)
Message-ID: <4D8C4764.7060107@googlemail.com>
Date: Fri, 25 Mar 2011 08:42:28 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Disabling ACKs with ath5k
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless list!

Is there an interface to disable transmission of ACKs and on the other
hand ignoring unreceived ACKs. It can be done with multicasting, but can
it also be achieved by a setting with non-multicast-traffic? I am using
ath5k.

Kind regards,
Dennis
