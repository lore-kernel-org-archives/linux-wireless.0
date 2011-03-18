Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56953 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab1CRPoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 11:44:17 -0400
Received: by bwz15 with SMTP id 15so3450724bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 08:44:16 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Juan Carlos Garza <juancarlosgarza@gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in AP and IBSS
Date: Fri, 18 Mar 2011 16:42:28 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Johannes Stezenbach <js@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com> <201103172107.25316.helmut.schaa@googlemail.com> <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
In-Reply-To: <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103181642.28386.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for testing Juan.

Am Freitag, 18. März 2011 schrieb Juan Carlos Garza:
> I applied the patches (manually), and tested the stick.
> 
> The transfer of big loads now is successful.

Ivo, Johannes, are there any issues left with the async tx status
patches for rt2800usb (in the experimental branch) as they seem to
lower the chance for missed tx status reports.

Helmut
