Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from briare1.fullpliant.org ([78.227.24.35]:44467 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757257Ab1CBLHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 06:07:42 -0500
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: linux-wireless@vger.kernel.org
Subject: 32 bits executables with 64 bits kernel wifi issue
Date: Wed, 02 Mar 2011 11:54:07 GMT
Message-ID: <0B3412811@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

If I use a 32 bits kernel, then I can connect to any Wifi box,
but if I use a 64 bits kernel with 32 bits executables,
it will connect on some Wifi boxes (french Freebox), but fail to connect to others (french Livebox).

The wifi driver used is iwl3945.
When connection fails, WPA supplicant will report successfull association,
but udhcpc will fail to get a lease.
It does not seem to be related to a peticular kernel release: I tested with 2.6.36.4,
but get the same problem with 2.6.32.28 64 bits.

Regards,
Hubert Tonneau

