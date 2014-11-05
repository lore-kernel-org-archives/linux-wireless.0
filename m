Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64590 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKEJOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:14:43 -0500
Received: by mail-wg0-f51.google.com with SMTP id l18so371427wgh.38
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 01:14:42 -0800 (PST)
MIME-Version: 1.0
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 5 Nov 2014 10:14:22 +0100
Message-ID: <CAGnRvuraknR46wWwqaSFiYQ5YtSSMB0S3pcdQeC_8fOAUGQ-UA@mail.gmail.com> (sfid-20141105_101448_417371_F1E660D1)
Subject: Tun/tap-variant for 802.15.4/6lowpan?
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working with a external radio module controlled over a serial
port and would like to use the linux 6lowpan implementation to make it
IP capable.

Is there something like the tun/tap-driver for 6lowpan that delivers
the raw frames back to userspace over a socket?

Henning Rogge
